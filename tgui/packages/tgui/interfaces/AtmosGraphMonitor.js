import { useBackend } from '../backend';
import { Section, LabeledList, Box } from '../components';
import { Window } from '../layouts';
import { pureComponentHooks } from '../../common/react';
import { zipWith, map } from '../../common/collections';
import { Component, createRef } from 'inferno';
import { toFixed } from '../../common/math';

export const AtmosGraphMonitor = (props, context) => {
  const { act, data } = useBackend(context);

  let sensors_list = data.sensors || {};
  // Найдём последние значения давления и температуры для каждого датчика
  const lastPressureToSensor = {};
  const lastTemperatureToSensor = {};
  for (const sensor in sensors_list) {
    lastPressureToSensor[sensor] =
      sensors_list[sensor].pressure_history.slice(-1)[0];
    lastTemperatureToSensor[sensor] =
      sensors_list[sensor].temperature_history.slice(-1)[0];
  }

  // Найдём максимальные значения давления и температуры для каждого датчика
  const maxPressureToSensor = {};
  const maxTemperatureToSensor = {};
  for (const sensor in sensors_list) {
    maxPressureToSensor[sensor] = Math.max(
      ...sensors_list[sensor].pressure_history
    );
    maxTemperatureToSensor[sensor] = Math.max(
      ...sensors_list[sensor].temperature_history
    );
  }

  // Приведём данные в нужный формат
  const pressureDataToSensor = {};
  const temperatureDataToSensor = {};
  for (const sensor in sensors_list) {
    pressureDataToSensor[sensor] = sensors_list[sensor].pressure_history.map(
      (value, index) => [index, value]
    );
    temperatureDataToSensor[sensor] = sensors_list[
      sensor
    ].temperature_history.map((value, index) => [index, value]);
  }

  return (
    <Window width={700} height={400}>
      <Window.Content scrollable>
        {Object.keys(sensors_list).map((s) => (
          <Section key={s} title={s}>
            <LabeledList>
              {/* ДАВЛЕНИЕ */}
              {Object.keys(sensors_list[s]).indexOf('pressure_history') > -1 ? (
                <LabeledList.Item
                  label={
                    'Давление (' + toFixed(lastPressureToSensor[s], 0) + ' кПа)'
                  }
                >
                  <Section fill height={5} mx={1} mt={0.5}>
                    <AtmosChart
                      fillPositionedParent
                      data={pressureDataToSensor[s]}
                      rangeX={[0, pressureDataToSensor[s].length - 1]}
                      rangeY={[0, maxPressureToSensor[s] + 5]}
                      strokeColor="rgba(219, 40, 40, 1)"
                      fillColor="rgba(219, 40, 40, 0.1)"
                    />
                  </Section>
                </LabeledList.Item>
              ) : (
                ''
              )}

              {/* ТЕМПЕРАТУРА */}
              {Object.keys(sensors_list[s]).indexOf('temperature_history') >
              -1 ? (
                <LabeledList.Item
                  label={
                    'Температура (' +
                    toFixed(lastTemperatureToSensor[s], 0) +
                    ' K)'
                  }
                >
                  <Section fill height={5} mx={1} mt={0.5}>
                    <AtmosChart
                      fillPositionedParent
                      data={temperatureDataToSensor[s]}
                      rangeX={[0, temperatureDataToSensor[s].length - 1]}
                      rangeY={[0, maxTemperatureToSensor[s] + 5]}
                      strokeColor="rgba(40, 219, 40, 1)"
                      fillColor="rgba(40, 219, 40, 0.1)"
                    />
                  </Section>
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

// СПИЗЖЕННЫЙ КОД КОМПОНЕНТА CHART.JS

const normalizeData = (data, scale, rangeX, rangeY) => {
  if (data.length === 0) {
    return [];
  }
  const min = zipWith(Math.min)(...data);
  const max = zipWith(Math.max)(...data);
  if (rangeX !== undefined) {
    min[0] = rangeX[0];
    max[0] = rangeX[1];
  }
  if (rangeY !== undefined) {
    min[1] = rangeY[0];
    max[1] = rangeY[1];
  }
  const normalized = map((point) => {
    return zipWith((value, min, max, scale) => {
      return ((value - min) / (max - min)) * scale;
    })(point, min, max, scale);
  })(data);
  return normalized;
};

const dataToPolylinePoints = (data) => {
  let points = '';
  for (let i = 0; i < data.length; i++) {
    const point = data[i];
    points += point[0] + ',' + point[1] + ' ';
  }
  return points;
};

class AtmosChart extends Component {
  constructor(props) {
    super(props);
    this.ref = createRef();
    this.state = {
      // Initial guess
      viewBox: [400, 800],
    };
    this.handleResize = () => {
      const element = this.ref.current;
      this.setState({
        viewBox: [element.offsetWidth, element.offsetHeight],
      });
    };
  }

  componentDidMount() {
    window.addEventListener('resize', this.handleResize);
    this.handleResize();
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleResize);
  }
  render() {
    const {
      data = [],
      rangeX,
      rangeY,
      fillColor = 'none',
      strokeColor = '#ffffff',
      strokeWidth = 2,
      ...rest
    } = this.props;
    const { viewBox } = this.state;
    const normalized = normalizeData(data, viewBox, rangeX, rangeY);
    // Push data outside viewBox and form a fillable polygon
    if (normalized.length > 0) {
      const first = normalized[0];
      const last = normalized[normalized.length - 1];
      normalized.push([viewBox[0] + strokeWidth, last[1]]);
      normalized.push([viewBox[0] + strokeWidth, -strokeWidth]);
      normalized.push([-strokeWidth, -strokeWidth]);
      normalized.push([-strokeWidth, first[1]]);
    }
    const points = dataToPolylinePoints(normalized);
    const horizontalLinesCount = 2; // Горизонтальные линии сетки, не имеют физического смысла
    const verticalLinesCount = data.length - 2;
    const gridColor = 'rgba(255, 255, 255, 0.1)';
    const gridWidth = 2;
    const pointTextColor = 'rgba(255, 255, 255, 0.8)';
    const pointTextSize = '0.8em';

    return (
      <Box position="relative" {...rest}>
        {(props) => (
          <div ref={this.ref} {...props}>
            <svg
              viewBox={`0 0 ${viewBox[0]} ${viewBox[1]}`}
              preserveAspectRatio="none"
              style={{
                position: 'absolute',
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                overflow: 'hidden',
              }}
            >
              {/* Горизонтальные линии сетки */}
              {Array.from({ length: horizontalLinesCount }).map((_, index) => (
                <line
                  key={`horizontal-line-${index}`}
                  x1={0}
                  y1={(index + 1) * (viewBox[1] / (horizontalLinesCount + 1))}
                  x2={viewBox[0]}
                  y2={(index + 1) * (viewBox[1] / (horizontalLinesCount + 1))}
                  stroke={gridColor}
                  strokeWidth={gridWidth}
                />
              ))}
              {/* Вертикальные линии сетки */}
              {Array.from({ length: verticalLinesCount }).map((_, index) => (
                <line
                  key={`vertical-line-${index}`}
                  x1={(index + 1) * (viewBox[0] / (verticalLinesCount + 1))}
                  y1={0}
                  x2={(index + 1) * (viewBox[0] / (verticalLinesCount + 1))}
                  y2={viewBox[1]}
                  stroke={gridColor}
                  strokeWidth={gridWidth}
                />
              ))}
              {/* Полилиния графика */}
              <polyline
                transform={`scale(1, -1) translate(0, -${viewBox[1]})`}
                fill={fillColor}
                stroke={strokeColor}
                strokeWidth={strokeWidth}
                points={points}
              />
              {/* Точки */}
              {data.map(
                (point, index) =>
                  index % 2 === 1 && (
                    <circle
                      key={`point-${index}`}
                      cx={normalized[index][0]}
                      cy={viewBox[1] - normalized[index][1]}
                      r={2} // радиус точки
                      fill="#ffffff" // цвет точки
                      stroke={strokeColor} // цвет обводки
                      strokeWidth={1} // ширина обводки
                    />
                  )
              )}
              {/* Значения точек */}
              {data.map(
                (point, index) =>
                  index % 2 === 1 && (
                    <text
                      key={`point-text-${index}`}
                      x={normalized[index][0]}
                      y={viewBox[1] - normalized[index][1]}
                      fill={pointTextColor}
                      fontSize={pointTextSize}
                      dy="1em" // Сдвиг текста вниз, чтобы он не перекрывал точку
                      dx="-2.5em" // Сдвиг текста вправо
                      textAnchor="middle" // Центрирование текста по x координате
                    >
                      {point[1] !== null ? point[1].toFixed(0) : 'N/A'}
                    </text>
                  )
              )}
            </svg>
          </div>
        )}
      </Box>
    );
  }
}

AtmosChart.defaultHooks = pureComponentHooks;
