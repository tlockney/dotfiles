// Matches the join URLs of the conferencing services we actually encounter.
const MEETING_URL_PATTERN =
  /https?:\/\/[^\s<>"']*(?:zoom\.us\/j\/|meet\.google\.com\/|teams\.microsoft\.com\/l\/meetup-join|webex\.com\/(?:meet\/|join\/|[^\s<>"']*j\.php))[^\s<>"']*/i;

export function extractMeetingUrl(
  ...sources: Array<string | undefined>
): string | undefined {
  for (const source of sources) {
    const match = source?.match(MEETING_URL_PATTERN);
    if (match) return match[0];
  }
  return undefined;
}
