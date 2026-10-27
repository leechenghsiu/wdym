import test from 'node:test';
import assert from 'node:assert/strict';
import { intake, explain, markdown } from '../dist/content.mjs';

test('keeps meaningful line breaks, removes control codes, rejects empty and oversized input', () => {
  assert.equal(intake(' \ufefffirst\r\nsecond\u0000 '), 'first\nsecond');
  assert.throws(() => intake('  \n '), /文字/);
  assert.throws(() => intake('x'.repeat(40001)), /40,000/);
});
test('matches whole known phrases without inventing an explanation for other content', () => {
  assert.equal(explain('What is a shared browser session?').id, 'session');
  assert.equal(explain('RACE CONDITION').id, 'race');
  assert.equal(explain('context compaction').id, 'context');
  assert.equal(explain('unrelated question').id, 'unknown');
  assert.equal(explain('<script>alert(1)</script>').id, 'unknown');
});
test('exports the complete original and identifies the reply as a demonstration', () => {
  const source = 'a long original\nwith a second line';
  const output = markdown(source, explain(source));
  assert.ok(output.includes(source));
  assert.ok(output.includes('示範'));
});
