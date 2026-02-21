# Website backend

> [!TIP]
>
> This is a simple backend model for a website.

## Model 📚

There are four tables:

- `users` with information about the users
- `events` with a record of login, logout, and login failure events
- `google_auth` with users' Google authentication activity
- `password_auth` with users' email and password authentication activity

The users can use Google, email and password, or both for authentication to log into the website.

The authentication tables keep track of the latest activity for each user for the corresponding authentication type, and the `events` table records a history of all login, logout, and login failure events.
