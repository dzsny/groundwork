---
name: A hook misfired
about: A hook blocked something legitimate, fired too often, or stayed silent when it shouldn't
title: "[hook] "
labels: hooks
---

**Which hook** <!-- session-context / design-drift / commit-lint -->

**Policy setting** <!-- off / warn / enforce -->

**What happened**

**What should have happened**

**Payload, if you have it**

```json
```

<!-- Hooks must fail open: a hook that breaks a session, or blocks under anything but an
explicit `enforce` policy, is a bug regardless of whether its judgment was right. -->
