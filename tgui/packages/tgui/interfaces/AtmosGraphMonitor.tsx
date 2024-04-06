import { useBackend, useLocalState } from '../backend';
import { Section, Box, Tabs, Icon, Chart } from '../components';
import { Window } from '../layouts';
import { toFixed } from '../../common/math';

type SensorsData = {
  [key: string]: {
    pressure_history: number[];
    temperature_history: number[];
    long_pressure_history: number[];
    long_temperature_history: number[];
  };
};

export const AtmosGraphMonitor = (props, context) => {
  const { data } = useBackend<SensorsData>(context);
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);
  const decideTab = (index) => {
    switch (index) {
      case 0:
        return (
          <AtmosGraphPage
            data={data}
            info="Интервал записи T = 60 с. | Интервал между записями t = 3с."
            pressureListName="pressure_history"
            temperatureListName="temperature_history"
          />
        );
      case 1:
        return (
          <AtmosGraphPage
            data={data}
            info="Интервал записи T = 10 Мин. | Интервал между записями t = 30с."
            pressureListName="long_pressure_history"
            temperatureListName="long_temperature_history"
          />
        );

      default:
        return "WE SHOULDN'T BE HERE!";
    }
  };
  const maxWingowHeight = 800;
  const getWindowHeight = Math.min(
    maxWingowHeight,
    Object.keys(data.sensors).length * 220 + 150
  );
  return (
    <Window width={700} height={getWindowHeight}>
      <Window.Content scrollable>
        <Box fillPositionedParent>
          <Tabs>
            <Tabs.Tab
              key="View"
              selected={tabIndex === 0}
              onClick={() => setTabIndex(0)}
            >
              <Icon name="area-chart" /> Текущие
            </Tabs.Tab>
            <Tabs.Tab
              key="History"
              selected={tabIndex === 1}
              onClick={() => setTabIndex(1)}
            >
              <Icon name="bar-chart" /> История
            </Tabs.Tab>
          </Tabs>
          {decideTab(tabIndex)}
          {Object.keys(data.sensors).length === 0 && (
            <Box
              pt={2}
              textAlign={'center'}
              textColor={'gray'}
              bold
              fontSize={1.3}
            >
              Подключите gas sensor или meter с помощью multitool
            </Box>
          )}
        </Box>
      </Window.Content>
    </Window>
  );
};

const AtmosGraphPage = ({
  data,
  info,
  pressureListName,
  temperatureListName,
}) => {
  let sensors_list = data.sensors || {};

  const getLastReading = (sensor, listName) =>
    sensors_list[sensor][listName].slice(-1)[0];
  const getMinReading = (sensor, listName) =>
    Math.min(...sensors_list[sensor][listName]);
  const getMaxReading = (sensor, listName) =>
    Math.max(...sensors_list[sensor][listName]);
  const getDataToSensor = (sensor, listName) =>
    sensors_list[sensor][listName].map((value, index) => [index, value]);

  return (
    <Box>
      <Section color={'gray'}>{info}</Section>
      {Object.keys(sensors_list).map((s) => (
        <Section key={s} title={s}>
          <Section px={2}>
            {/* ТЕМПЕРАТУРА */}
            {temperatureListName in sensors_list[s] && (
              <Box mb={2}>
                <Box>
                  {'Температура: ' +
                    toFixed(getLastReading(s, temperatureListName), 0) +
                    'К (MIN: ' +
                    toFixed(getMinReading(s, temperatureListName), 0) +
                    'К;' +
                    ' MAX: ' +
                    toFixed(getMaxReading(s, temperatureListName), 0) +
                    'К)'}
                </Box>
                <Section fill height={5} mt={1}>
                  <Chart.Line
                    fillPositionedParent
                    data={getDataToSensor(s, temperatureListName)}
                    rangeX={[
                      0,
                      getDataToSensor(s, temperatureListName).length - 1,
                    ]}
                    rangeY={[0, getMaxReading(s, temperatureListName) + 5]}
                    strokeColor="rgba(219, 40, 40, 1)"
                    fillColor="rgba(219, 40, 40, 0.1)"
                  />
                </Section>
              </Box>
            )}

            {/* ДАВЛЕНИЕ */}
            {pressureListName in sensors_list[s] && (
              <Box mb={-1}>
                <Box>
                  {'Давление: ' +
                    toFixed(getLastReading(s, pressureListName), 0) +
                    'кПа (MIN: ' +
                    toFixed(getMinReading(s, pressureListName), 0) +
                    'кПа;' +
                    ' MAX: ' +
                    toFixed(getMaxReading(s, pressureListName), 0) +
                    'кПа)'}
                </Box>
                <Section fill height={5} mt={1}>
                  <Chart.Line
                    fillPositionedParent
                    data={getDataToSensor(s, pressureListName)}
                    rangeX={[
                      0,
                      getDataToSensor(s, pressureListName).length - 1,
                    ]}
                    rangeY={[0, getMaxReading(s, pressureListName) + 5]}
                    strokeColor="rgba(40, 219, 40, 1)"
                    fillColor="rgba(40, 219, 40, 0.1)"
                  />
                </Section>
              </Box>
            )}
          </Section>
        </Section>
      ))}
    </Box>
  );
};
