import {
  Box,
  Button,
  Dimmer,
  Flex,
  Icon,
  Knob,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { ComplexModal } from './common/ComplexModal';

interface DNAModifierData {
  irradiating: number;
  dnaBlockSize: number;
  locked: boolean;
  hasOccupant: boolean;
  hasDisk: boolean;
  isBeakerLoaded: boolean;
  isInjectorReady: boolean;
  selectedMenuKey: string;
  selectedUIBlock: number;
  selectedUISubBlock: number;
  selectedUITarget: number;
  selectedSEBlock: number;
  selectedSESubBlock: number;
  radiationIntensity: number;
  radiationDuration: number;
  beakerVolume: number;
  beakerLabel: string | null;
  occupant: {
    name: string;
    stat: number;
    health: number;
    minHealth: number;
    maxHealth: number;
    radiationLevel: number;
    isViableSubject: boolean;
    uniqueIdentity: string;
    uniqueEnzymes: string | null;
    structuralEnzymes: string;
  };
  disk: {
    data: boolean;
    label: string | null;
    owner: string | null;
    type: 'ui' | 'se';
    ue: boolean;
  };
  buffers: Array<{
    data: boolean;
    label: string;
    owner: string | null;
    type: 'ui' | 'se';
    ue: boolean;
  }>;
}

const stats: [string, string][] = [
  ['good', 'Жив'],
  ['average', 'Критический'],
  ['bad', 'МЁРТВ'],
];

const operations: [string, string, string][] = [
  ['ui', 'Изменение внешности', 'dna'],
  ['se', 'Развитие мутаций', 'dna'],
  ['buffer', 'База данных', 'syringe'],
  ['rejuvenators', 'Стабилизаторы', 'flask'],
];

const rejuvenatorsDoses: number[] = [5, 10, 20, 30, 50];

export const DNAModifier = () => {
  const { act, data } = useBackend<DNAModifierData>();
  const { irradiating, dnaBlockSize, occupant } = data;
  const isDNAInvalid = !occupant.isViableSubject || !occupant.uniqueIdentity || !occupant.structuralEnzymes;
  let radiatingModal;
  if (irradiating) {
    radiatingModal = <DNAModifierIrradiating duration={irradiating} />;
  }
  return (
    <Window width={660} height={800}>
      <ComplexModal />
      {radiatingModal}
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <DNAModifierOccupant isDNAInvalid={isDNAInvalid} />
          </Stack.Item>
          <Stack.Item grow>
            <DNAModifierMain dnaBlockSize={dnaBlockSize} isDNAInvalid={isDNAInvalid} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

interface DNAModifierOccupantProps {
  isDNAInvalid: boolean;
}

const DNAModifierOccupant = (props: DNAModifierOccupantProps) => {
  const { act, data } = useBackend<DNAModifierData>();
  const { locked, hasOccupant, occupant } = data;
  const { isDNAInvalid } = props;
  return (
    <Section
      title="Испытуемый"
      buttons={
        <>
          <Box color="label" inline mr="0.5rem">
            Блокировка:
          </Box>
          <Button
            disabled={!hasOccupant}
            selected={locked}
            icon={locked ? 'toggle-on' : 'toggle-off'}
            content={locked ? 'Включена' : 'Выключена'}
            onClick={() => act('toggleLock')}
          />
          <Button
            disabled={!hasOccupant || locked}
            icon="user-slash"
            content="Выпустить"
            onClick={() => act('ejectOccupant')}
          />
        </>
      }
    >
      {hasOccupant ? (
        <>
          <Box>
            <LabeledList>
              <LabeledList.Item label="Имя">{occupant.name}</LabeledList.Item>
              <LabeledList.Item label="Здоровье">
                <ProgressBar
                  minValue={occupant.minHealth}
                  maxValue={occupant.maxHealth}
                  value={occupant.health / occupant.maxHealth}
                  ranges={{
                    good: [0.5, Infinity],
                    average: [0, 0.5],
                    bad: [-Infinity, 0],
                  }}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Статус" color={stats[occupant.stat][0]}>
                {stats[occupant.stat][1]}
              </LabeledList.Item>
              <LabeledList.Divider />
            </LabeledList>
          </Box>
          {isDNAInvalid ? (
            <Box color="bad">
              <Icon name="exclamation-circle" />
              &nbsp; Структура ДНК субъекта критически повреждена.
            </Box>
          ) : (
            <LabeledList>
              <LabeledList.Item label="Уровень облучения">
                <ProgressBar minValue={0} maxValue={100} value={occupant.radiationLevel / 100} color="average" />
              </LabeledList.Item>
              <LabeledList.Item label="Уникальный геном">
                {data.occupant.uniqueEnzymes ? (
                  data.occupant.uniqueEnzymes
                ) : (
                  <Box color="bad">
                    <Icon name="exclamation-circle" />
                    &nbsp; Неизвестно
                  </Box>
                )}
              </LabeledList.Item>
            </LabeledList>
          )}
        </>
      ) : (
        <Box color="label">Камера пуста.</Box>
      )}
    </Section>
  );
};

interface DNAModifierMainProps {
  dnaBlockSize: number;
  isDNAInvalid: boolean;
}

const DNAModifierMain = (props: DNAModifierMainProps) => {
  const { act, data } = useBackend<DNAModifierData>();
  const { selectedMenuKey, hasOccupant } = data;
  const { dnaBlockSize, isDNAInvalid } = props;

  if (!hasOccupant) {
    return (
      <Section fill>
        <Stack fill>
          <Stack.Item grow align="center" textAlign="center" color="label">
            <Icon name="user-slash" mb="0.5rem" size={5} />
            <br />
            Испытуемый отсутствует.
          </Stack.Item>
        </Stack>
      </Section>
    );
  } else if (isDNAInvalid) {
    return (
      <Section fill>
        <Stack fill>
          <Stack.Item grow align="center" textAlign="center" color="label">
            <Icon name="user-slash" mb="0.5rem" size={5} />
            <br />
            Операции над данным субъектом невозможны.
          </Stack.Item>
        </Stack>
      </Section>
    );
  }
  let body;
  if (selectedMenuKey === 'ui') {
    body = (
      <>
        <DNAModifierMainUI dnaBlockSize={dnaBlockSize} />
        <DNAModifierMainRadiationEmitter />
      </>
    );
  } else if (selectedMenuKey === 'se') {
    body = (
      <>
        <DNAModifierMainSE dnaBlockSize={dnaBlockSize} />
        <DNAModifierMainRadiationEmitter />
      </>
    );
  } else if (selectedMenuKey === 'buffer') {
    body = <DNAModifierMainBuffers />;
  } else if (selectedMenuKey === 'rejuvenators') {
    body = <DNAModifierMainRejuvenators />;
  }
  return (
    <Section fill>
      <Tabs>
        {operations.map((op, i) => (
          <Tabs.Tab
            key={i}
            icon={op[2]}
            selected={selectedMenuKey === op[0]}
            onClick={() => act('selectMenuKey', { key: op[0] })}
          >
            {op[1]}
          </Tabs.Tab>
        ))}
      </Tabs>
      {body}
    </Section>
  );
};

interface DNAModifierMainUIProps {
  dnaBlockSize: number;
}

const DNAModifierMainUI = (props: DNAModifierMainUIProps) => {
  const { act, data } = useBackend<DNAModifierData>();
  const { selectedUIBlock, selectedUISubBlock, selectedUITarget, occupant } = data;
  const { dnaBlockSize } = props;
  return (
    <Section title="Модифицировать - Уникальную внешность">
      <Stack vertical>
        <Stack.Item grow>
          <Section>
            <DNAModifierBlocks
              dnaString={occupant.uniqueIdentity}
              selectedBlock={selectedUIBlock}
              selectedSubblock={selectedUISubBlock}
              blockSize={dnaBlockSize}
              action="selectUIBlock"
            />
          </Section>
        </Stack.Item>
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item label="Целевое">
              <Knob
                minValue={1}
                maxValue={15}
                stepPixelSize={20}
                value={selectedUITarget}
                format={(value) => value.toString(16).toUpperCase()}
                ml="0"
                onChange={(e, val) => act('changeUITarget', { value: val })}
              />
            </LabeledList.Item>
          </LabeledList>
          <Button icon="radiation" content="Облучить ячейку" mt="0.5rem" onClick={() => act('pulseUIRadiation')} />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

interface DNAModifierMainSEProps {
  dnaBlockSize: number;
}

const DNAModifierMainSE = (props: DNAModifierMainSEProps) => {
  const { act, data } = useBackend<DNAModifierData>();
  const { selectedSEBlock, selectedSESubBlock, occupant } = data;
  const { dnaBlockSize } = props;
  return (
    <Section title="Модифицировать - Нестандартные мутации">
      <Stack vertical>
        <Stack.Item grow>
          <Section>
            <DNAModifierBlocks
              dnaString={occupant.structuralEnzymes}
              selectedBlock={selectedSEBlock}
              selectedSubblock={selectedSESubBlock}
              blockSize={dnaBlockSize}
              action="selectSEBlock"
            />
          </Section>
        </Stack.Item>
        <Stack.Item>
          <Button icon="radiation" content="Облучить ячейку" onClick={() => act('pulseSERadiation')} />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const DNAModifierMainRadiationEmitter = () => {
  const { act, data } = useBackend<DNAModifierData>();
  const { radiationIntensity, radiationDuration } = data;
  return (
    <Section title="Излучатель радиации">
      <LabeledList>
        <LabeledList.Item label="Интенсивность">
          <Knob
            minValue={1}
            maxValue={10}
            stepPixelSize={20}
            value={radiationIntensity}
            popupPosition="right"
            ml="0"
            onChange={(e, val) => act('radiationIntensity', { value: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Перезарядка">
          <Knob
            minValue={1}
            maxValue={20}
            stepPixelSize={10}
            unit="с"
            value={radiationDuration}
            popupPosition="right"
            ml="0"
            onChange={(e, val) => act('radiationDuration', { value: val })}
          />
        </LabeledList.Item>
      </LabeledList>
      <Button
        icon="radiation"
        content="Пульс-излучение"
        tooltip="Мутирует случайную ячейку уникальной внешности или нестандартной мутации."
        tooltipPosition="top-start"
        mt="0.5rem"
        onClick={() => act('pulseRadiation')}
      />
    </Section>
  );
};

const DNAModifierMainBuffers = () => {
  const { data } = useBackend<DNAModifierData>();
  const { buffers } = data;
  let bufferElements = buffers.map((buffer, i) => (
    <DNAModifierMainBuffersElement key={i} id={i + 1} name={'Буфер ' + (i + 1)} buffer={buffer} />
  ));
  return (
    <Stack fill vertical>
      <Stack.Item height="75%" mt={1}>
        <Section fill scrollable title="Буферы данных о ДНК">
          {bufferElements}
        </Section>
      </Stack.Item>
      <Stack.Item height="25%">
        <DNAModifierMainBuffersDisk />
      </Stack.Item>
    </Stack>
  );
};

interface BufferData {
  data: boolean;
  label: string;
  owner: string | null;
  type: 'ui' | 'se';
  ue: boolean;
}

interface DNAModifierMainBuffersElementProps {
  id: number;
  name: string;
  buffer: BufferData;
}

const DNAModifierMainBuffersElement = (props: DNAModifierMainBuffersElementProps) => {
  const { act, data } = useBackend<DNAModifierData>();
  const { id, name, buffer } = props;
  const isInjectorReady = data.isInjectorReady;
  const realName = name + (buffer.data ? ' - ' + buffer.label : '');
  return (
    <Box backgroundColor="rgba(0, 0, 0, 0.33)" mb="0.5rem">
      <Section
        title={realName}
        mx="0"
        lineHeight="18px"
        buttons={
          <>
            <Button.Confirm
              disabled={!buffer.data}
              icon="trash"
              content="Очистить"
              onClick={() =>
                act('bufferOption', {
                  option: 'clear',
                  id: id,
                })
              }
            />
            <Button
              disabled={!buffer.data}
              icon="pen"
              content="Переименовать"
              onClick={() =>
                act('bufferOption', {
                  option: 'changeLabel',
                  id: id,
                })
              }
            />
            <Button
              disabled={!buffer.data || !data.hasDisk}
              icon="save"
              content="Экспорт"
              tooltip="Копирует данные буфера на диск установленный в консоль."
              tooltipPosition="bottom-start"
              onClick={() =>
                act('bufferOption', {
                  option: 'saveDisk',
                  id: id,
                })
              }
            />
          </>
        }
      >
        <LabeledList>
          <LabeledList.Item label="Запись">
            <Button
              icon="arrow-circle-down"
              content="Только внешность"
              mb="0"
              onClick={() =>
                act('bufferOption', {
                  option: 'saveUI',
                  id: id,
                })
              }
            />
            <Button
              icon="arrow-circle-down"
              content="Полный геном"
              mb="0"
              onClick={() =>
                act('bufferOption', {
                  option: 'saveUIAndUE',
                  id: id,
                })
              }
            />
            <Button
              icon="arrow-circle-down"
              content="Только мутации"
              mb="0"
              onClick={() =>
                act('bufferOption', {
                  option: 'saveSE',
                  id: id,
                })
              }
            />
            <Button
              disabled={!data.hasDisk || !data.disk.data}
              icon="arrow-circle-down"
              content="Запись диска"
              mb="0"
              onClick={() =>
                act('bufferOption', {
                  option: 'loadDisk',
                  id: id,
                })
              }
            />
          </LabeledList.Item>
          {!!buffer.data && (
            <>
              <LabeledList.Item label="Субъект">
                {buffer.owner || <Box color="average">Неизвестно</Box>}
              </LabeledList.Item>
              <LabeledList.Item label="Тип данных">
                {buffer.type === 'ui' ? 'Уникальная внешность' : 'Нестандартные мутации'}
                {!!buffer.ue && ' и Копирование личности'}
              </LabeledList.Item>
              <LabeledList.Item label="Тип инъектора">
                <Button
                  disabled={!isInjectorReady}
                  icon={isInjectorReady ? 'syringe' : 'spinner'}
                  iconSpin={!isInjectorReady}
                  content="Полный геном"
                  tooltip="Полностью выделяет генетический код внешности или набора мутаций в один инъектор."
                  tooltipPosition="bottom-start"
                  mb="0"
                  onClick={() =>
                    act('bufferOption', {
                      option: 'createInjector',
                      id: id,
                    })
                  }
                />
                <Button
                  disabled={!isInjectorReady}
                  icon={isInjectorReady ? 'syringe' : 'spinner'}
                  iconSpin={!isInjectorReady}
                  content="Один блок"
                  tooltip="Выборочно отделяет один выбранный блок с геномом для выдачи конкретной мутации или части внешности."
                  tooltipPosition="bottom-start"
                  mb="0"
                  onClick={() =>
                    act('bufferOption', {
                      option: 'createInjector',
                      id: id,
                      block: 1,
                    })
                  }
                />
                <Button
                  icon="user"
                  content="Копирование генома"
                  tooltip="Существенно облучает пациента, меняя его клеточную структуру под данные в буфере."
                  tooltipPosition="bottom-start"
                  mb="0"
                  onClick={() =>
                    act('bufferOption', {
                      option: 'transfer',
                      id: id,
                    })
                  }
                />
              </LabeledList.Item>
            </>
          )}
        </LabeledList>
        {!buffer.data && (
          <Box color="label" mt="0.5rem">
            Этот буфер пустой.
          </Box>
        )}
      </Section>
    </Box>
  );
};

const DNAModifierMainBuffersDisk = () => {
  const { act, data } = useBackend<DNAModifierData>();
  const { hasDisk, disk } = data;
  return (
    <Section
      title="Диск с данными"
      buttons={
        <>
          <Button.Confirm
            disabled={!hasDisk || !disk.data}
            icon="trash"
            content="Стереть"
            onClick={() => act('wipeDisk')}
          />
          <Button disabled={!hasDisk} icon="eject" content="Извлечь" onClick={() => act('ejectDisk')} />
        </>
      }
    >
      {hasDisk ? (
        disk.data ? (
          <LabeledList>
            <LabeledList.Item label="Метка">{disk.label ? disk.label : 'Нет метки'}</LabeledList.Item>
            <LabeledList.Item label="Субъект">
              {disk.owner ? disk.owner : <Box color="average">Неизвестно</Box>}
            </LabeledList.Item>
            <LabeledList.Item label="Тип данных">
              {disk.type === 'ui' ? 'Уникальная внешность' : 'Нестандартные мутации'}
              {!!disk.ue && ' и Копирование личности'}
            </LabeledList.Item>
          </LabeledList>
        ) : (
          <Box color="label">Диск не имеет данных.</Box>
        )
      ) : (
        <Box color="label" textAlign="center" my="1rem">
          <Icon name="save-o" size={4} />
          <br />
          Диск с данными не вставлен.
        </Box>
      )}
    </Section>
  );
};

const DNAModifierMainRejuvenators = () => {
  const { act, data } = useBackend<DNAModifierData>();
  const { isBeakerLoaded, beakerVolume, beakerLabel } = data;
  return (
    <Section
      fill
      title="Камера реагентов"
      buttons={
        <Button disabled={!isBeakerLoaded} icon="eject" content="Извлечь ёмкость" onClick={() => act('ejectBeaker')} />
      }
    >
      {isBeakerLoaded ? (
        <LabeledList>
          <LabeledList.Item label="Ввести">
            {rejuvenatorsDoses.map((a, i) => (
              <Button
                key={i}
                disabled={a > beakerVolume}
                icon="syringe"
                content={a}
                onClick={() =>
                  act('injectRejuvenators', {
                    amount: a,
                  })
                }
              />
            ))}
            <Button
              disabled={beakerVolume <= 0}
              icon="syringe"
              content="Всё"
              onClick={() =>
                act('injectRejuvenators', {
                  amount: beakerVolume,
                })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item label="Название">
            <Box mb="0.5rem">{beakerLabel ? beakerLabel : 'Отсутствует'}</Box>
            {beakerVolume ? (
              <Box color="good">
                Осталось {beakerVolume} юнит{beakerVolume === 1 ? '' : 'ов'}
              </Box>
            ) : (
              <Box color="bad">Пусто</Box>
            )}
          </LabeledList.Item>
        </LabeledList>
      ) : (
        <Stack fill vertical align="center" justify="center">
          <Stack.Item>
            <Icon.Stack>
              <Icon name="flask" size={5} color="silver" />
              <Icon name="slash" size={5} color="red" />
            </Icon.Stack>
          </Stack.Item>
          <Stack.Item color="label" mb="2rem">
            <Box bold>Ёмкость не установлена</Box>
          </Stack.Item>
        </Stack>
      )}
    </Section>
  );
};

interface DNAModifierIrradiatingProps {
  duration: number;
}

const DNAModifierIrradiating = (props: DNAModifierIrradiatingProps) => {
  const { duration } = props;
  return (
    <Dimmer textAlign="center">
      <Icon name="spinner" size={5} spin />
      <br />
      <Box color="average">
        <Box fontSize="1.5rem" bold>
          <Icon name="radiation" />
          &nbsp;Облучаем испытуемого&nbsp;
          <Icon name="radiation" />
        </Box>
      </Box>
      <Box color="label">
        <Box bold>В течение {duration} сек.</Box>
      </Box>
    </Dimmer>
  );
};

interface DNAModifierBlocksProps {
  dnaString: string;
  selectedBlock: number;
  selectedSubblock: number;
  blockSize: number;
  action: string;
}

const DNAModifierBlocks = (props: DNAModifierBlocksProps) => {
  const { act } = useBackend<DNAModifierData>();
  const { dnaString, selectedBlock, selectedSubblock, blockSize, action } = props;

  const characters = dnaString.split('');
  // Explicitly type the arrays to fix TypeScript errors
  const dnaBlocks: React.ReactNode[] = [];

  for (let block = 0; block < characters.length; block += blockSize) {
    const realBlock = block / blockSize + 1;
    const subBlocks: React.ReactNode[] = [];

    for (let subblock = 0; subblock < blockSize; subblock++) {
      const realSubblock = subblock + 1;
      subBlocks.push(
        <Button
          key={subblock}
          selected={selectedBlock === realBlock && selectedSubblock === realSubblock}
          content={characters[block + subblock]}
          mb="0"
          onClick={() =>
            act(action, {
              block: realBlock,
              subblock: realSubblock,
            })
          }
        />
      );
    }

    dnaBlocks.push(
      <Stack.Item key={block} mb="1rem" mr="1rem" width={7.8} textAlign="right">
        <Box inline mr="0.5rem" fontFamily="monospace">
          {realBlock}
        </Box>
        {subBlocks}
      </Stack.Item>
    );
  }

  return <Flex wrap="wrap">{dnaBlocks}</Flex>;
};
