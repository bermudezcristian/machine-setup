# YubiKey Enrollment Checklist

Two keys: **Primary** (keychain, daily) and **Backup** (stored safely, separate location).

Golden rule: register **both** keys on every account, verify each account lists two keys,
then store the backup away.

## Tooling

```sh
brew install ykman                        # CLI: configure keys, set FIDO2 PIN
brew install --cask yubico-authenticator  # GUI: TOTP codes stored on-device
```

## One-time hardening (run per key — do it for BOTH)

```sh
ykman info                     # confirm the key + its enabled applications
ykman fido access change-pin   # set FIDO2 PIN (protects passkeys/FIDO2)
ykman fido info                # verify PIN is set
# optional:
ykman oath access change       # set OATH password (protects TOTP codes)
```

## Account enrollment

For each account: Settings → Security → Security Keys → Add key.
Register the **backup** key too, then confirm the account shows **two** keys.

| Account            | Primary | Backup | Notes                          |
|--------------------|:-------:|:------:|--------------------------------|
| Google             |   [ ]   |  [ ]   | Passkeys and security keys     |
| GitHub             |   [ ]   |  [ ]   | Password and authentication    |
| GitLab             |   [ ]   |  [ ]   |                                |
| 1Password          |   [ ]   |  [ ]   | Both keys as unlock methods    |
| Bitwarden          |   [ ]   |  [ ]   |                                |
| Cloudflare         |   [ ]   |  [ ]   |                                |
| AWS                |   [ ]   |  [ ]   |                                |
| Microsoft / Entra  |   [ ]   |  [ ]   |                                |
| Apple ID           |   [ ]   |  [ ]   | Security Keys                  |
| Dropbox            |   [ ]   |  [ ]   |                                |

## Don't skip

- [ ] Save recovery/backup codes (password manager or printed).
- [ ] Remove weak SMS 2FA on important accounts (now that keys are redundant).
- [ ] Store the backup key separate from the primary.
- [ ] Every few months, authenticate once with the backup to confirm it still works.

## If a key is lost

1. Use the other key to log in.
2. Remove the lost key from **every** account's security settings.
3. Enroll a replacement key so you're back to two.
