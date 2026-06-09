# Contributing

Contributions are welcome. This project is meant to be a generic starting point
for a self-hosted home server, so fixes and improvements that keep it generic and
reusable are especially appreciated.

## Reporting issues

Open an issue describing the problem. Helpful details include:

- What you expected to happen and what actually happened
- The relevant task or service
- Output from `ansible-playbook run.yml` or `docker logs <container>`
- Your Ubuntu and Ansible versions

## Pull requests

1. Fork the repository and create a branch for your change.
2. Keep changes focused; one logical change per pull request.
3. Run a syntax check before submitting:

   ```bash
   ansible-playbook run.yml --syntax-check
   ```

4. Never commit secrets or host-specific values. All secrets belong in the
   gitignored, encrypted `group_vars/all/vault.yml`, and host-specific values in
   `group_vars/all/local.yml`. Double-check your diff before pushing.
5. If you add a service, also add it to `roles/services/tasks/main.yml`, document
   it in [serviceslist.md](serviceslist.md), and note any required variables in
   [variablehelp.md](variablehelp.md).

## Style

Follow the patterns already used in the existing roles and tasks. Use the
`community.docker` and `ansible.builtin` modules rather than raw shell commands
where possible, and reference configuration through variables instead of
hard-coding values.
