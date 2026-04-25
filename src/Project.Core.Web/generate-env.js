// Generates src/environments/environment.generated.ts from environment variables
// injected by Aspire (or falls back to development defaults).
const fs = require('fs');
const path = require('path');

const authority = process.env['KEYCLOAK_AUTHORITY'] || 'http://localhost:8080/realms/projectcore';
const apiUrl = process.env['API_URL'] || 'http://localhost:5000';

const content = `// AUTO-GENERATED — do not edit. Run \`node generate-env.js\` to regenerate.
export const generatedEnvironment = {
  authority: '${authority}',
  apiUrl: '${apiUrl}',
};
`;

const outPath = path.join(__dirname, 'src', 'environments', 'environment.generated.ts');
fs.mkdirSync(path.dirname(outPath), { recursive: true });
fs.writeFileSync(outPath, content, 'utf8');
console.log('environment.generated.ts written:', outPath);
