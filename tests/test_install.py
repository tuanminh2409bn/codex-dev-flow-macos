"""Exercise installer behavior against isolated destinations, never the live home."""
import pathlib
import subprocess
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]


class InstallTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = pathlib.Path(self.tmp.name)
        self.config = self.root / "config with spaces"
        self.skill = self.root / "skills with spaces" / "dev-flow"

    def run_install(self, *extra):
        return subprocess.run(
            ["bash", str(ROOT / "install.sh"), "--config-dir", str(self.config),
             "--skill-dir", str(self.skill), *extra],
            capture_output=True, text=True,
        )

    def assert_skill_matches(self):
        source = ROOT / "skills/dev-flow"
        expected = {p.relative_to(source): p.read_bytes()
                    for p in source.rglob("*") if p.is_file()}
        actual = {p.relative_to(self.skill): p.read_bytes()
                  for p in self.skill.rglob("*") if p.is_file()}
        self.assertEqual(expected, actual)

    def test_fresh_install_and_repeated_install(self):
        for _ in range(2):
            result = self.run_install()
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assert_skill_matches()
        self.assertEqual((self.config / "AGENTS.md").read_bytes(),
                         (ROOT / "config/AGENTS.md").read_bytes())
        self.assertFalse(list(self.config.glob("AGENTS.md.proposed-*")))

    def test_custom_guidance_and_old_skill_are_preserved(self):
        self.config.mkdir()
        original = b"# Private rules\n\nKeep project-specific restrictions.\n"
        (self.config / "AGENTS.md").write_bytes(original)
        self.skill.mkdir(parents=True)
        (self.skill / "old-reference.md").write_text("Old custom reference")
        for _ in range(2):
            result = self.run_install()
            self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual((self.config / "AGENTS.md").read_bytes(), original)
        proposals = list(self.config.glob("AGENTS.md.proposed-*"))
        self.assertEqual(len(proposals), 2)
        for p in proposals:
            self.assertEqual(p.read_bytes(), (ROOT / "config/AGENTS.md").read_bytes())
        backups = list((self.config / "backups").iterdir())
        self.assertEqual(len(backups), 2)
        self.assertTrue(any((p / "dev-flow/old-reference.md").exists() for p in backups))
        self.assert_skill_matches()

    def test_symlink_skill_is_rejected_without_touching_target(self):
        target = self.root / "original"
        target.mkdir()
        marker = target / "keep.txt"
        marker.write_text("unchanged")
        self.skill.parent.mkdir()
        self.skill.symlink_to(target, target_is_directory=True)
        self.assertNotEqual(self.run_install().returncode, 0)
        self.assertEqual(marker.read_text(), "unchanged")
        self.assertTrue(self.skill.is_symlink())

    def test_missing_argument_fails_before_writing(self):
        self.assertNotEqual(self.run_install("--skill-dir").returncode, 0)
        self.assertFalse(self.config.exists())


if __name__ == "__main__":
    unittest.main()
