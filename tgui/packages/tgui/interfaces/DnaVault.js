import { useBackend } from '../backend';
import {
  Box,
  Button,
  Grid,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

export const DnaVault = (props, context) => {
  const { act, data } = useBackend(context);
  const { completed } = data;
  return (
    <Window>
      <Window.Content>
        <DnaVaultDataBase />
        {!!completed && <GeneTherapySelection />}
      </Window.Content>
    </Window>
  );
};

const DnaVaultDataBase = (props, context) => {
  const { act, data } = useBackend(context);
  const { dna, dna_max, plants, plants_max, animals, animals_max } = data;
  const average_progress = 0.66;
  const bad_progress = 0.33;
  return (
    <Section title="База данных хранилища ДНК">
      <LabeledList>
        <LabeledList.Item label="ДНК гуманоидов">
          <ProgressBar
            value={dna / dna_max}
            ranges={{
              good: [average_progress, Infinity],
              average: [bad_progress, average_progress],
              bad: [-Infinity, bad_progress],
            }}
          >
            {dna + ' / ' + dna_max + ' образцов'}
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="ДНК растений">
          <ProgressBar
            value={plants / plants_max}
            ranges={{
              good: [average_progress, Infinity],
              average: [bad_progress, average_progress],
              bad: [-Infinity, bad_progress],
            }}
          >
            {plants + ' / ' + plants_max + ' образцов'}
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="ДНК животных">
          <ProgressBar
            value={animals / animals_max}
            ranges={{
              good: [average_progress, Infinity],
              average: [bad_progress, average_progress],
              bad: [-Infinity, bad_progress],
            }}
          >
            {animals + ' / ' + animals_max + ' образцов'}
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const GeneTherapySelection = (props, context) => {
  const { act, data } = useBackend(context);
  const { choiceA, choiceB, used } = data;
  return (
    <Section title="Персональная генная терапия">
      <Box bold textAlign="center" mb={1}>
        Предлагаемые генетические модификации
      </Box>
      {(!used && (
        <Grid>
          <Grid.Column>
            <Button
              fluid
              bold
              content={choiceA}
              textAlign="center"
              onClick={() =>
                act('gene', {
                  choice: choiceA,
                })
              }
            />
          </Grid.Column>
          <Grid.Column>
            <Button
              fluid
              bold
              content={choiceB}
              textAlign="center"
              onClick={() =>
                act('gene', {
                  choice: choiceB,
                })
              }
            />
          </Grid.Column>
        </Grid>
      )) || (
        <Box bold textAlign="center" mb={1}>
          ДНК пользователя нестабильна. Новые обновления недоступны.
        </Box>
      )}
    </Section>
  );
};
