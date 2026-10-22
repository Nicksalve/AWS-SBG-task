# Raspberry Pi Wi-Fi Extender Setup – Web Page

**AWS Student Builder Group at VIT Pune · Pre-Interview Task 1: Deploy a Website**

A one-page website that shows a step-by-step guide (as a single image) for turning a Raspberry Pi into a Wi-Fi extender using `nmcli`. The page centres the image and scales it to fit any screen size, on desktop and mobile.

## Submission

| Item | Link |
|------|------|
| Live website | https://aws-sbg-task-1.vercel.app |
| GitHub repository | https://github.com/Nicksalve/AWS-SBG-task.git |
| Screenshot | see below |

### Screenshot of the deployed site

![Deployed website](screenshot.png)

## Hosting platform: GitHub Pages

I chose **GitHub Pages** because:

- The site is static (one HTML file and one image), so it needs no server-side code.
- It is free, needs no server to maintain, and serves the site over HTTPS automatically.
- It deploys directly from the Git repository, so every push to `main` updates the live site.

The repository also contains a `Dockerfile` and `nginx.conf` so the same site can be run as an **nginx container**, either locally or on a cloud VM (for example AWS EC2 or Lightsail). GitHub Pages ignores these files and serves the static files directly.

## Technologies used

- **HTML + CSS:** a single page (styles are inside `index.html`) that displays the image, sized to fit any screen
- **GitHub Pages:** the hosting platform for the live site
- **Git + GitHub:** version control and code hosting
- **nginx + Docker (optional):** to run the same site as a container locally or on a cloud server

## Files

| File | Purpose |
|------|---------|
| `index.html` | The page and its styles; it shows `image.png` centred on a background matching the image |
| `image.png` | The guide image |
| `screenshot.png` | Screenshot of the live site (part of the submission) |
| `Dockerfile` | Builds an nginx image with the site inside (optional, not used by GitHub Pages) |
| `nginx.conf` | nginx settings: serve `index.html`, cache the PNG for a day |
| `.dockerignore` | Keeps `.git`, the README and so on out of the Docker image |

## How it was deployed (GitHub Pages)

1. Create a **public** repository on GitHub and push this folder:
   ```bash
   git remote add origin https://github.com/<your-github-username>/<repo-name>.git
   git push -u origin main
   ```
2. On GitHub, go to **Settings → Pages**, set **Source** to **Deploy from a branch**, then pick branch `main` and folder `/ (root)`. Click **Save**.
3. After about a minute the site is live at `https://<your-github-username>.github.io/<repo-name>/`.

Any later `git push` to `main` redeploys the site automatically.

## Run locally with nginx in Docker (optional)

Requirements: Docker (or Podman, which accepts the same commands).

```bash
git clone https://github.com/<your-github-username>/<repo-name>.git
cd <repo-name>
docker build -t pi-extender-site .
docker run -d --name pi-site -p 8080:80 pi-extender-site
```

Open http://127.0.0.1:8080 in a browser.

Useful commands:
```bash
docker logs pi-site      # see nginx's access log
docker rm -f pi-site     # stop and remove the container
```

After you change any file, run `docker rm -f pi-site`, then repeat the `build` and `run` commands.

To host the container on a cloud server instead (AWS EC2 or Lightsail free tier): install Docker on a small Linux server, clone the repo, run the same `docker build`, start the container with `-p 80:80`, allow inbound **port 80** in the security group, and open `http://<server-public-ip>`.

## Troubleshooting

- **The image doesn't show:** make sure the file is named exactly `image.png` (names are case-sensitive on Linux and on GitHub Pages).
- **GitHub Pages shows 404:** check that the repository is public, Pages is enabled on branch `main` / folder `/ (root)`, and `index.html` is in the repository root. Wait a minute and refresh.
- **`short-name "nginx:alpine" did not resolve`:** Podman requires full image names. The Dockerfile already uses `docker.io/library/nginx:alpine`.
- **`localhost:8080` gives "connection reset":** use `http://127.0.0.1:8080` instead (rootless Podman port forwarding doesn't support IPv6).
- **"Port already in use":** an old container is still running. Run `docker rm -f pi-site`.
