# Build APK on GitHub

This project is prepared for a GitHub Actions Android APK build.

1. Extract this ZIP on your phone.
2. Upload the **contents** of the extracted folder to the root of your GitHub repository (not the ZIP itself).
3. Commit the files to the `main` branch.
4. Open the repository's **Actions** tab.
5. Select **Build Android APK** and run it with **Run workflow** (a push to `main` also starts it automatically).
6. When the job finishes, open the completed workflow run and download the artifact named **insight-editor-release-apk**.

The workflow creates the missing Android platform files automatically before building.
