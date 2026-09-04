import { render, screen } from '@testing-library/react';
import App from './App';

test('renders the architecture heading', () => {
  render(<App />);
  expect(
    screen.getByRole('heading', { name: /aws secure 3-tier architecture/i })
  ).toBeInTheDocument();
});
