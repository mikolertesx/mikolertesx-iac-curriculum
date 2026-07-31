import { useEffect, useState } from 'react';

const VISITOR_ENDPOINT =
  'https://njtp9nve1m.execute-api.us-east-1.amazonaws.com/prod/visitors';

function formatVisitorLabel(visitors: number | string): string {
  const n = Number(visitors);
  if (!Number.isFinite(n)) {
    return `${visitors} visitors`;
  }
  return n === 1 ? '1 visitor' : `${n} visitors`;
}

export function VisitorCount() {
  const [label, setLabel] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;

    async function trackVisit() {
      try {
        const res = await fetch(VISITOR_ENDPOINT, { method: 'POST' });
        if (!res.ok) {
          throw new Error('Request failed');
        }
        const data: { visitors?: number | string } = await res.json();
        if (!cancelled && data.visitors !== undefined) {
          setLabel(formatVisitorLabel(data.visitors));
        }
      } catch {
        // Keep the count hidden if the request fails.
      }
    }

    void trackVisit();

    return () => {
      cancelled = true;
    };
  }, []);

  if (!label) {
    return null;
  }

  return <span className="visitor-count">{label}</span>;
}
