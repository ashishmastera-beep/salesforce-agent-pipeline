# Flow Best Practices (read before editing Flow XML)
- Name elements descriptively (Get_Case, Screen_Confirm); unique names; connect every element.
- Fault paths on all Get/Create/Update elements -> error screen with {!$Flow.FaultMessage}.
- Keep screen flows short (2-3 screens); validate inputs on-screen, not after.
- Deploy as Draft unless spec says Active; verify in Flow Builder debug mode after deploy.
