# Quickstart: Skill Rating Support

## Prerequisites
- Flutter dependencies are installed.
- The app can run locally on the target platform.

## Verify the Skill Experience
1. Launch the app and open `ResumeFormPage`.
2. Add a skill from the Skills section.
3. Choose a rating from 1 to 5.
4. Save and reopen the form to confirm the skill name and rating are preserved.
5. Verify the skill item shows the name, a rating label, and visible stars.

## Verify Consistency with the Profile Flow
1. Open `EditProfilePage`.
2. Add or edit a skill using the existing skill editor.
3. Confirm the rating scale matches the resume form experience.
4. Compare the displayed stars and rating meaning between both pages.

## Regression Check
1. Confirm no other resume form sections changed behavior.
2. Confirm the Skills section still handles empty and populated states cleanly.
3. Run the test suite before merging changes.

## Recommended Validation Commands
```bash
flutter test
```

```bash
flutter run
```
