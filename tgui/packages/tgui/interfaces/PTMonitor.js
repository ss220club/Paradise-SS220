import { useBackend } from '../backend';
import { Box, ProgressBar } from '../components';
import { Window } from '../layouts';

export const PTMonitor = (props, context) => {
  const { act, data } = useBackend(context);
  const { description, name } = data;
  return (
    <Window>
      <Window.Content>
        <Box>
          {description}
          <br />
          {name}
        </Box>
        <ProgressBar
          ranges={{
            good: [0.5, Infinity],
            average: [0.25, 0.5],
            bad: [-Infinity, 0.25],
          }}
          value={0.6}
        />
      </Window.Content>
    </Window>
  );
};
