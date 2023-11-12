import { useBackend } from '../backend';
import { Button, LabeledList, Section, ProgressBar } from '../components';
import { Window } from '../layouts';

export const SatelliteControl = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    satellites,
    notice,
    meteor_shield,
    meteor_shield_coverage,
    meteor_shield_coverage_max,
    meteor_shield_coverage_percentage,
  } = data;
  return (
    <Window resizable>
      <Window.Content scrollable>
        {meteor_shield && (
          <Section title="Покрытие станции спутниками">
            <ProgressBar
              color={
                meteor_shield_coverage_percentage >= 100 ? 'good' : 'average'
              }
              value={meteor_shield_coverage}
              maxValue={meteor_shield_coverage_max}
            >
              {meteor_shield_coverage_percentage} %
            </ProgressBar>
          </Section>
        )}
        <Section title="Управление сетью спутников">
          <LabeledList>
            {notice && (
              <LabeledList.Item label="Внимание" color="red">
                {data.notice}
              </LabeledList.Item>
            )}
            {satellites.map((sat) => (
              <LabeledList.Item key={sat.id} label={'#' + sat.id}>
                {sat.mode}{' '}
                <Button
                  content={sat.active ? 'Деактивировать' : 'Активировать'}
                  icon={'arrow-circle-right'}
                  onClick={() => act('toggle', { id: sat.id })}
                />
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
