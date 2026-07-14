# LWC Best Practices (read before writing LWC)
- Prefer LDS (@wire getRecord) over Apex; cacheable=true Apex for read-only data.
- One responsibility per component; compose small components.
- Template: conditional rendering for loading/error/empty states; SLDS classes over custom CSS.
- JS: no direct DOM manipulation; use @api/@track correctly; handle promise rejections.
- Meta XML: isExposed true, sensible masterLabel, correct targets (lightning__RecordPage etc.).
