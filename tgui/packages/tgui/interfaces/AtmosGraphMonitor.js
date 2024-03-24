import { useBackend } from '../backend';
import {
  Button,
  Section,
  NumberInput,
  LabeledList,
  ProgressBar,
} from '../components';
import { toFixed } from 'common/math';
import { getGasColor, getGasLabel } from '../constants';
import { Window } from '../layouts';

export const AtmosGraphMonitor = (props, context) => {
  const { act, data } = useBackend(context);

  let sensors_list = data.sensors || {};

  return (
    <Window width={600} height={400}>
      <Window.Content scrollable>
        {Object.keys(sensors_list).map((s) => (
          <Section key={s} title={s}>
            <LabeledList>
              {Object.keys(sensors_list[s]).indexOf('pressure_history') > -1 ? (
                <LabeledList.Item label="История давлений (kpa)">
                  {sensors_list[s]['pressure_history'].join(', ')}
                </LabeledList.Item>
              ) : (
                ''
              )}
              {Object.keys(sensors_list[s]).indexOf('temperature_history') >
              -1 ? (
                <LabeledList.Item label="История температур (K)">
                  {sensors_list[s]['temperature_history'].join(', ')}
                </LabeledList.Item>
              ) : (
                ''
              )}
            </LabeledList>
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};
