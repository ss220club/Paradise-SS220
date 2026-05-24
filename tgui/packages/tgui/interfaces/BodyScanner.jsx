import {
  AnimatedNumber,
  Box,
  Button,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
  Table,
  Tooltip,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import { useBackend } from '../backend';
import { Window } from '../layouts';

const stats = [
  ['good', 'Живой'],
  ['average', 'Критическое состояние'],
  ['bad', 'МЁРТВ'],
];

const abnormalities = [
  ['hasVirus', 'bad', 'Вирусный возбудитель обнаружен в кровотоке.'],
  ['blind', 'average', 'Обнаружена катаракта.'],
  ['colourblind', 'average', 'Обнаружены нарушения в работе фоторецепторов.'],
  ['nearsighted', 'average', 'Обнаружено смещение сетчатки.'],
  ['paraplegic', 'bad', 'Повреждены поясничные нервы.'],
];

const damages = [
  ['Удушье', 'oxyLoss'],
  ['Повреждения мозга', 'brainLoss'],
  ['Токсины', 'toxLoss'],
  ['Облучённость', 'radLoss'],
  ['Ушибы', 'bruteLoss'],
  ['Генетические повреждения', 'cloneLoss'],
  ['Ожоги', 'fireLoss'],
  ['Опьянение', 'drunkenness'],
];

const damageRange = {
  average: [0.25, 0.5],
  bad: [0.5, Infinity],
};

const mapTwoByTwo = (a, c) => {
  let result = [];
  for (let i = 0; i < a.length; i += 2) {
    result.push(c(a[i], a[i + 1], i));
  }
  return result;
};

const reduceOrganStatus = (A) => {
  return A.length > 0
    ? A.filter((s) => !!s).reduce(
        (a, s) => (
          <>
            {a}
            <Box key={s}>{s}</Box>
          </>
        ),
        null
      )
    : null;
};

const germStatus = (i) => {
  if (i > 100) {
    if (i < 300) {
      return 'лёгкая инфекция';
    }
    if (i < 400) {
      return 'лёгкая инфекция+';
    }
    if (i < 500) {
      return 'лёгкая инфекция++';
    }
    if (i < 700) {
      return 'острая инфекция';
    }
    if (i < 800) {
      return 'острая инфекция+';
    }
    if (i < 900) {
      return 'острая инфекция++';
    }
    if (i >= 900) {
      return 'заражение';
    }
  }

  return '';
};

export const BodyScanner = (props) => {
  const { data } = useBackend();
  const { occupied, occupant = {} } = data;
  const body = occupied ? <BodyScannerMain occupant={occupant} /> : <BodyScannerEmpty />;
  return (
    <Window width={700} height={600} title="Анализатор тела">
      <Window.Content scrollable>{body}</Window.Content>
    </Window>
  );
};

const BodyScannerMain = (props) => {
  const { occupant } = props;
  return (
    <Box>
      <BodyScannerMainOccupant occupant={occupant} />
      <BodyScannerMainAbnormalities occupant={occupant} />
      <BodyScannerMainDamage occupant={occupant} />
      <BodyScannerMainOrgansExternal organs={occupant.extOrgan} />
      <BodyScannerMainOrgansInternal organs={occupant.intOrgan} />
    </Box>
  );
};

const BodyScannerMainOccupant = (props) => {
  const { act, data } = useBackend();
  const { occupant } = data;
  return (
    <Section
      title="Пациент"
      buttons={
        <>
          <Button icon="print" onClick={() => act('print_p')}>
            Распечатать скан тела
          </Button>
          <Button icon="user-slash" onClick={() => act('ejectify')}>
            Достать пациента
          </Button>
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Имя">{occupant.name}</LabeledList.Item>
        <LabeledList.Item label="Состояние">
          <ProgressBar
            min="0"
            max={occupant.maxHealth}
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
        <LabeledList.Item label="Температура">
          <AnimatedNumber value={Math.round(occupant.bodyTempC)} />
          &deg;C,&nbsp;
          <AnimatedNumber value={Math.round(occupant.bodyTempF)} />
          &deg;F
        </LabeledList.Item>
        <LabeledList.Item label="Био-чипы">
          {occupant.implant_len ? (
            <Box>{occupant.implant.map((im) => im.name).join(', ')}</Box>
          ) : (
            <Box color="label">Не обнаружены</Box>
          )}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const BodyScannerMainAbnormalities = (props) => {
  const { occupant } = props;
  if (
    !(
      occupant.hasBorer ||
      occupant.blind ||
      occupant.colourblind ||
      occupant.nearsighted ||
      occupant.hasVirus ||
      occupant.paraplegic
    )
  ) {
    return (
      <Section title="Отклонения">
        <Box color="label">Отклонения не обнаружены.</Box>
      </Section>
    );
  }

  return (
    <Section title="Отклонения">
      {abnormalities.map((a, i) => {
        if (occupant[a[0]]) {
          return (
            <Box key={a[2]} color={a[1]} bold={a[1] === 'bad'}>
              {a[2]}
            </Box>
          );
        }
      })}
    </Section>
  );
};

const BodyScannerMainDamage = (props) => {
  const { occupant } = props;
  return (
    <Section title="Основные показатели">
      <Table>
        {mapTwoByTwo(damages, (d1, d2, i) => (
          <>
            <Table.Row color="label">
              <Table.Cell width="50%">{d1[0]}:</Table.Cell>
              <Table.Cell width="50%">{!!d2 && d2[0] + ':'}</Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell width="50%">
                <BodyScannerMainDamageBar value={occupant[d1[1]]} marginBottom={i < damages.length - 2} />
              </Table.Cell>
              <Table.Cell width="50%">{!!d2 && <BodyScannerMainDamageBar value={occupant[d2[1]]} />}</Table.Cell>
            </Table.Row>
          </>
        ))}
      </Table>
    </Section>
  );
};

const BodyScannerMainDamageBar = (props) => {
  return (
    <ProgressBar
      min="0"
      max="100"
      value={props.value / 100}
      mt="0.5rem"
      mb={!!props.marginBottom && '0.5rem'}
      ranges={damageRange}
    >
      {Math.round(props.value)}
    </ProgressBar>
  );
};

const BodyScannerMainOrgansExternal = (props) => {
  if (props.organs.length === 0) {
    return (
      <Section title="Внешние части тела">
        <Box color="label">N/A</Box>
      </Section>
    );
  }

  return (
    <Section title="Внешние части тела">
      <Table>
        <Table.Row header>
          <Table.Cell>Название</Table.Cell>
          <Table.Cell textAlign="center">Состояние</Table.Cell>
          <Table.Cell textAlign="right">Повреждения</Table.Cell>
        </Table.Row>
        {props.organs.map((o, i) => (
          <Table.Row key={i}>
            <Table.Cell
              color={
                (!!o.status.dead && 'bad') ||
                ((!!o.internalBleeding ||
                  !!o.burnWound ||
                  !!o.lungRuptured ||
                  !!o.liverCirrhosis ||
                  !!o.status.broken ||
                  !!o.open ||
                  o.germ_level > 100) &&
                  'average') ||
                (!!o.status.robotic && 'label')
              }
              width="33%"
            >
              {capitalize(o.name)}
            </Table.Cell>
            <Table.Cell textAlign="center">
              <ProgressBar
                m={-0.5}
                min="0"
                max={o.maxHealth}
                mt={i > 0 && '0.5rem'}
                value={o.totalLoss / o.maxHealth}
                ranges={damageRange}
              >
                <Stack>
                  <Tooltip content="Суммарные повреждения">
                    <Stack.Item>
                      <Icon name="heartbeat" mr={0.5} />
                      {Math.round(o.totalLoss)}
                    </Stack.Item>
                  </Tooltip>
                  {!!o.bruteLoss && (
                    <Tooltip content="Травмы">
                      <Stack.Item grow>
                        <Icon name="bone" mr={0.5} />
                        {Math.round(o.bruteLoss)}
                      </Stack.Item>
                    </Tooltip>
                  )}
                  {!!o.fireLoss && (
                    <Tooltip content="Ожоги">
                      <Stack.Item>
                        <Icon name="fire" mr={0.5} />
                        {Math.round(o.fireLoss)}
                      </Stack.Item>
                    </Tooltip>
                  )}
                </Stack>
              </ProgressBar>
            </Table.Cell>
            <Table.Cell textAlign="right" verticalAlign="top" width="33%" pt={i > 0 && 'calc(0.5rem + 2px)'}>
              <Box color="average" inline>
                {reduceOrganStatus([
                  !!o.internalBleeding && 'Internal bleeding',
                  !!o.burnWound && 'Critical tissue burns',
                  !!o.lungRuptured && 'Ruptured lung',
                  !!o.liverCirrhosis && 'Liver cirrhosis',
                  !!o.status.broken && o.status.broken,
                  germStatus(o.germ_level),
                  !!o.open && 'Open incision',
                ])}
              </Box>
              <Box inline>
                {reduceOrganStatus([
                  !!o.status.splinted && <Box color="good">Splinted</Box>,
                  !!o.status.robotic && <Box color="label">Robotic</Box>,
                  !!o.status.dead && (
                    <Box color="bad" bold>
                      DEAD
                    </Box>
                  ),
                ])}
                {reduceOrganStatus(o.shrapnel.map((s) => (s.known ? s.name : 'Unknown object')))}
              </Box>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const BodyScannerMainOrgansInternal = (props) => {
  if (props.organs.length === 0) {
    return (
      <Section title="Внутренние органы">
        <Box color="label">N/A</Box>
      </Section>
    );
  }

  return (
    <Section title="Внутренние органы">
      <Table>
        <Table.Row header>
          <Table.Cell>Название</Table.Cell>
          <Table.Cell textAlign="center">Состояние</Table.Cell>
          <Table.Cell textAlign="right">Повреждения</Table.Cell>
        </Table.Row>
        {props.organs.map((o, i) => (
          <Table.Row key={i}>
            <Table.Cell
              color={(!!o.dead && 'bad') || (o.germ_level > 100 && 'average') || (o.robotic > 0 && 'label')}
              width="33%"
            >
              {capitalize(o.name)}
            </Table.Cell>
            <Table.Cell textAlign="center">
              <ProgressBar
                min="0"
                max={o.maxHealth}
                value={o.damage / o.maxHealth}
                mt={i > 0 && '0.5rem'}
                ranges={damageRange}
              >
                {Math.round(o.damage)}
              </ProgressBar>
            </Table.Cell>
            <Table.Cell textAlign="right" verticalAlign="top" width="33%" pt={i > 0 && 'calc(0.5rem + 2px)'}>
              <Box color="average" inline>
                {reduceOrganStatus([germStatus(o.germ_level)])}
              </Box>
              <Box inline>
                {reduceOrganStatus([
                  o.robotic === 1 && <Box color="label">Robotic</Box>,
                  o.robotic === 2 && <Box color="label">Assisted</Box>,
                  !!o.dead && (
                    <Box color="bad" bold>
                      DEAD
                    </Box>
                  ),
                ])}
              </Box>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const BodyScannerEmpty = () => {
  return (
    <Section fill>
      <Stack fill textAlign="center">
        <Stack.Item grow align="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size="5" />
          <br />
          Пациент не обнаружен.
        </Stack.Item>
      </Stack>
    </Section>
  );
};
