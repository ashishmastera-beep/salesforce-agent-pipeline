---
applyTo: "**/*.flow-meta.xml"
---
- Edit Flow XML surgically: preserve apiVersion, keep element names unique, wire every connector.
- Screen flows: 2-3 screens max for this repo; add fault paths on all DML elements to an error screen.
- Set <status>Active</status> only when the spec says so; otherwise Draft.
- After deploy, always instruct the human to open Flow Builder and run in debug mode to verify.
