import { useBackend } from '../backend';
import {
  Button,
  Collapsible,
  Flex,
  LabeledList,
  NoticeBox,
  Section,
  Slider,
  Box,
} from '../components';
import { Window } from '../layouts';
import { formatPower } from '../format';

export const BluespaceTap = (props, context) => {
  const { act, data } = useBackend(context);
  const product = data.product || [];
  const {
    desiredLevel,
    inputLevel,
    points,
    totalPoints,
    powerUse,
    availablePower,
    maxLevel,
    emagged,
    safeLevels,
    nextLevelPower,
  } = data;
  const barColor = (desiredLevel > inputLevel && 'bad') || 'good';
  return (
    <Window resizable>
      <Window.Content scrollable>
        {!!emagged && (
          <NoticeBox danger={1}>Протоколы безопасности отключены</NoticeBox>
        )}
        {!!(inputLevel > safeLevels) && (
          <NoticeBox danger={1}>Высокая мощность, возможна нестабильность</NoticeBox>
        )}
        <Collapsible title="Управление вводом">
          <Section title="Ввод">
            <LabeledList>
              <LabeledList.Item label="Текущий уровень">
                {inputLevel}
              </LabeledList.Item>
              <LabeledList.Item label="Целевой уровень">
                <Flex inline width="100%">
                  <Flex.Item>
                    <Button
                      icon="fast-backward"
                      disabled={desiredLevel === 0}
                      tooltip="Установить на 0"
                      onClick={() => act('set', { set_level: 0 })}
                    />
                    <Button
                      icon="step-backward"
                      tooltip="Понизить до текущего уровня"
                      disabled={desiredLevel === 0}
                      onClick={() => act('set', { set_level: inputLevel })}
                    />
                    <Button
                      icon="backward"
                      disabled={desiredLevel === 0}
                      tooltip="Понизить на шаг"
                      onClick={() => act('decrease')}
                    />
                  </Flex.Item>
                  <Flex.Item grow={1} mx={1}>
                    <Slider
                      value={desiredLevel}
                      fillValue={inputLevel}
                      minValue={0}
                      color={barColor}
                      maxValue={maxLevel}
                      stepPixelSize={20}
                      step={1}
                      onChange={(e, value) =>
                        act('set', {
                          set_level: value,
                        })
                      }
                    />
                  </Flex.Item>
                  <Flex.Item>
                    <Button
                      icon="forward"
                      disabled={desiredLevel === maxLevel}
                      tooltip="Повысить на шаг"
                      tooltipPosition="left"
                      onClick={() => act('increase')}
                    />
                    <Button
                      icon="fast-forward"
                      disabled={desiredLevel === maxLevel}
                      tooltip="Установить на максимум"
                      tooltipPosition="left"
                      onClick={() => act('set', { set_level: maxLevel })}
                    />
                  </Flex.Item>
                </Flex>
              </LabeledList.Item>
              <LabeledList.Item label="Текущее потребление энергии">
                {formatPower(powerUse)}
              </LabeledList.Item>
              <LabeledList.Item label="Энергии для следующего уровня">
                {formatPower(nextLevelPower)}
              </LabeledList.Item>
              <LabeledList.Item label="Доступно энергии">
                {formatPower(availablePower)}
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Collapsible>
        <Section title="Вывод">
          <Flex>
            <Flex.Item>
              <Box>
                <LabeledList>
                  <LabeledList.Item label="Доступно очков">
                    {points}
                  </LabeledList.Item>
                  <LabeledList.Item label="Всего очков">
                    {totalPoints}
                  </LabeledList.Item>
                </LabeledList>
              </Box>
            </Flex.Item>
            <Flex.Item align="end">
              <Box>
                <LabeledList>
                  {product.map((singleProduct) => (
                    <LabeledList.Item
                      key={singleProduct.key}
                      label={singleProduct.name}
                    >
                      <Button
                        disabled={singleProduct.price >= points}
                        onClick={() =>
                          act('vend', { target: singleProduct.key })
                        }
                        content={singleProduct.price}
                      />
                    </LabeledList.Item>
                  ))}
                </LabeledList>
              </Box>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
