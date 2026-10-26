import importlib.util
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "sync_openspec_skills",
    ROOT / "scripts" / "sync-openspec-skills.py",
)
SYNC = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(SYNC)

COMMIT_1 = "1" * 40
COMMIT_2 = "2" * 40


class SyncOpenSpecSkillsTests(unittest.TestCase):
    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.root = Path(self.temp_dir.name)
        self.repository = self.root / "repository"
        self.upstream = self.root / "upstream" / "skills"
        self.repository.mkdir()
        self.upstream.mkdir(parents=True)
        (self.repository / ".agents" / "skills" / "local-skill").mkdir(parents=True)
        (self.repository / ".agents" / "skills" / "local-skill" / "SKILL.md").write_text(
            "local project skill\n", encoding="utf-8"
        )
        self.report = self.root / "report.md"

    def tearDown(self):
        self.temp_dir.cleanup()

    def write_upstream(self, path: str, content: str):
        target = self.upstream / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(content, encoding="utf-8")

    def sync(self, commit: str):
        return SYNC.synchronize(
            self.repository,
            self.upstream,
            commit,
            self.report,
        )

    def test_import_translates_commands_and_no_change_creates_no_diff(self):
        self.write_upstream(
            "openspec-apply-change/SKILL.md",
            "Use `/openspec-apply-change add-auth` to apply.\n",
        )

        changed, report = self.sync(COMMIT_1)
        self.assertTrue(changed)
        skill = (
            self.repository
            / ".agents"
            / "skills"
            / "openspec-apply-change"
            / "SKILL.md"
        ).read_text(encoding="utf-8")
        self.assertIn("Bob: /opsx-apply add-auth", skill)
        self.assertIn("Claude Code: /opsx:apply add-auth", skill)
        self.assertTrue(
            (
                self.repository
                / ".agents"
                / "skills"
                / "local-skill"
                / "SKILL.md"
            ).exists()
        )
        self.assertIn(COMMIT_1, report)

        changed, _ = self.sync(COMMIT_1)
        self.assertFalse(changed)

    def test_updates_adds_removes_and_renames_upstream_managed_files(self):
        self.write_upstream("openspec-old/SKILL.md", "renamed skill\n")
        self.write_upstream("openspec-stable/SKILL.md", "version 1\n")
        self.sync(COMMIT_1)

        (self.upstream / "openspec-old" / "SKILL.md").unlink()
        (self.upstream / "openspec-old").rmdir()
        self.write_upstream("openspec-new/SKILL.md", "renamed skill\n")
        self.write_upstream("openspec-stable/SKILL.md", "version 2\n")
        changed, report = self.sync(COMMIT_2)

        self.assertTrue(changed)
        skills = self.repository / ".agents" / "skills"
        self.assertFalse((skills / "openspec-old").exists())
        self.assertEqual(
            (skills / "openspec-new" / "SKILL.md").read_text(encoding="utf-8"),
            "renamed skill\n",
        )
        self.assertEqual(
            (skills / "openspec-stable" / "SKILL.md").read_text(encoding="utf-8"),
            "version 2\n",
        )
        self.assertIn("openspec-old/SKILL.md", report)
        self.assertIn("openspec-new/SKILL.md", report)

    def test_preserves_local_edits_and_reports_conflicts(self):
        self.write_upstream("openspec-custom/SKILL.md", "upstream v1\n")
        self.sync(COMMIT_1)
        destination = (
            self.repository
            / ".agents"
            / "skills"
            / "openspec-custom"
            / "SKILL.md"
        )
        destination.write_text("local edit\n", encoding="utf-8")
        self.write_upstream("openspec-custom/SKILL.md", "upstream v2\n")

        changed, report = self.sync(COMMIT_2)

        self.assertTrue(changed)
        self.assertEqual(destination.read_text(encoding="utf-8"), "local edit\n")
        self.assertIn("locally modified file was preserved", report)

    def test_preserves_locally_modified_stale_files(self):
        self.write_upstream("openspec-removed/SKILL.md", "upstream v1\n")
        self.sync(COMMIT_1)
        destination = (
            self.repository
            / ".agents"
            / "skills"
            / "openspec-removed"
            / "SKILL.md"
        )
        destination.write_text("local edit\n", encoding="utf-8")
        (self.upstream / "openspec-removed" / "SKILL.md").unlink()
        (self.upstream / "openspec-removed").rmdir()

        changed, report = self.sync(COMMIT_2)

        self.assertTrue(changed)
        self.assertEqual(destination.read_text(encoding="utf-8"), "local edit\n")
        self.assertIn("stale locally modified path was preserved", report)

    def test_sync_workflow_is_weekly_manual_and_uses_pull_requests(self):
        workflow = (ROOT / ".github" / "workflows" / "sync-openspec-skills.yml").read_text(
            encoding="utf-8"
        )
        self.assertIn('cron: "0 9 * * 1"', workflow)
        self.assertIn("workflow_dispatch:", workflow)
        self.assertIn("peter-evans/create-pull-request@", workflow)
        self.assertIn("add-paths:", workflow)
        self.assertIn("body-path:", workflow)
        self.assertIn(".agents/skills/", workflow)
        self.assertIn(".github/openspec-skills-manifest.txt", workflow)


if __name__ == "__main__":
    unittest.main()
