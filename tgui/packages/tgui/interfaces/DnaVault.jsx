import { Box, Button, LabeledList, ProgressBar, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
// import { Grid } from '../components'; - SS220 EDIT Отключено из-за смены положения кнопок
import { Window } from '../layouts';

export const DnaVault = (props) => {
  const { act, data } = useBackend();
  const { completed } = data;
  return (
    <Window width={350} height={270}>
      <Window.Content>
        <Stack fill vertical>
          <DnaVaultDataBase />
          {!!completed && <GeneTherapySelection />}
        </Stack>
      </Window.Content>
    </Window>
  );
};

const DnaVaultDataBase = (props) => {
  const { act, data } = useBackend();
  const { dna, dna_max, plants, plants_max, animals, animals_max } = data;
  const average_progress = 0.66;
  const bad_progress = 0.33;
  return (
    <Stack.Item grow>
      <Section fill title="База данных ДНК-Хранилища">
        <LabeledList>
          <LabeledList.Item label="ДНК Гуманоидов">
            <ProgressBar
              value={dna / dna_max}
              ranges={{
                good: [average_progress, Infinity],
                average: [bad_progress, average_progress],
                bad: [-Infinity, bad_progress],
              }}
            >
              {dna + ' / ' + dna_max + ' Образцов'}
            </ProgressBar>
          </LabeledList.Item>
          <LabeledList.Item label="ДНК Растений">
            <ProgressBar
              value={plants / plants_max}
              ranges={{
                good: [average_progress, Infinity],
                average: [bad_progress, average_progress],
                bad: [-Infinity, bad_progress],
              }}
            >
              {plants + ' / ' + plants_max + ' Образцов'}
            </ProgressBar>
          </LabeledList.Item>
          <LabeledList.Item label="ДНК Животных">
            <ProgressBar
              value={animals / animals_max}
              ranges={{
                good: [average_progress, Infinity],
                average: [bad_progress, average_progress],
                bad: [-Infinity, bad_progress],
              }}
            >
              {animals + ' / ' + animals_max + ' Образцов'}
            </ProgressBar>
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </Stack.Item>
  );
};

const GeneTherapySelection = (props) => {
  const { act, data } = useBackend();
  const { choiceA, choiceB, used } = data;
  return (
    <Stack.Item>
      <Section fill title="Персональная генная терапия">
        <Box bold textAlign="center" mb={1}>
          Доступные выборы генной модификации
        </Box>
        {!used ? (
          <Stack vertical>
            <Stack.Item>
              <Button
                fluid
                bold
                content={choiceA}
                textAlign="center"
                onClick={() => act('gene', { choice: choiceA })}
              />
            </Stack.Item>

            <Stack.Item>
              <Button
                fluid
                bold
                content={choiceB}
                textAlign="center"
                onClick={() => act('gene', { choice: choiceB })}
              />
            </Stack.Item>
          </Stack>
        ) : (
          <Box bold textAlign="center" mb={1}>
            ДНК пользователя признана нестабильной. Дальнейшая терапия невозможна.
          </Box>
        )}
      </Section>
    </Stack.Item>
  );
};
