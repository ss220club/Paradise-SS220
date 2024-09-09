import { flow } from 'common/fp';
import { filter, sortBy } from 'common/collections';
import { useBackend, useSharedState } from '../backend';
import { Box, Button, Input, LabeledList, Section, Stack, Dropdown } from '../components';
import { Window } from '../layouts';
import { createSearch, toTitleCase } from 'common/string';

const canBeMade = (recipe, mavail, gavail, multi) => {
  if (recipe.requirements === null) {
    return true;
  }
  if (recipe.requirements['metal'] * multi > mavail) {
    return false;
  }
  if (recipe.requirements['glass'] * multi > gavail) {
    return false;
  }
  return true;
};

export const Autolathe220 = (props, context) => {
  return (
    <Window width={800} height={550}>
      <Window.Content>
        <Stack fill>
          <Stack.Item basis="25%">
            <Section fill scrollable title="Categories" />
          </Stack.Item>
          <Stack.Item basis="50%">
            <Section fill scrollable title="Recipes" />
          </Stack.Item>
          <Stack.Item basis="25%">
            <Stack fill vertical>
              <Stack.Item grow>
                <Section fill scrollable title="Materials" />
              </Stack.Item>
              <Stack.Item>
                <Section title="Queue" />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
