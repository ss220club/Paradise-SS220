/**
 * @file CombinedUploadConsole.tsx
 * TGUI-интерфейс для объединённой консоли аплоуда силиконов.
 * Размещать в: tgui/packages/tgui/interfaces/CombinedUploadConsole.tsx
 */

import { Box, Button, Icon, LabeledList, NoticeBox, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

// Константы режима — должны совпадать с DM-дефайнами
const MODE_NONE = 0;
const MODE_AI = 1;
const MODE_BORG = 2;

type SiliconTarget = {
  uid: number;
  name: string;
  alive: boolean;
};

type CombinedUploadData = {
  upload_mode: number;
  emagged: boolean;
  current_uid: number | null;
  current_name: string | null;
  current_alive: boolean;
  ai_list: SiliconTarget[];
  borg_list: SiliconTarget[];
};

export const CombinedUploadConsole = () => {
  const { data, act } = useBackend<CombinedUploadData>();
  const { upload_mode, emagged, current_uid, current_name, current_alive, ai_list, borg_list } = data;

  return (
    <Window title="Консоль аплоуда силиконов" width={440} height={520}>
      <Window.Content>
        <Stack vertical fill>
          {/* Шапка с предупреждением о emag */}
          {!!emagged && (
            <Stack.Item>
              <NoticeBox danger>
                <Icon name="skull" mr={1} />
                СИСТЕМА ВЗЛОМАНА — законы могут быть повреждены
              </NoticeBox>
            </Stack.Item>
          )}

          {/* Выбор режима */}
          <Stack.Item>
            <ModeSelector upload_mode={upload_mode} act={act} />
          </Stack.Item>

          {/* Текущая цель */}
          {upload_mode !== MODE_NONE && (
            <Stack.Item>
              <TargetDisplay current_name={current_name} current_alive={current_alive} act={act} />
            </Stack.Item>
          )}

          {/* Список целей */}
          {upload_mode !== MODE_NONE && (
            <Stack.Item grow>
              <TargetList
                upload_mode={upload_mode}
                ai_list={ai_list}
                borg_list={borg_list}
                current_uid={current_uid}
                act={act}
              />
            </Stack.Item>
          )}

          {/* Пустое состояние */}
          {upload_mode === MODE_NONE && (
            <Stack.Item grow>
              <Box height="100%" textAlign="center" color="label" mt={8}>
                <Icon name="satellite-dish" size={3} mb={2} />
                <br />
                Выберите режим работы консоли
              </Box>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};

// ─── Выбор режима ───────────────────────────────────────────────────────────

type ModeSelectorProps = {
  upload_mode: number;
  act: Function;
};

const ModeSelector = ({ upload_mode, act }: ModeSelectorProps) => (
  <Section title="Режим">
    <Stack>
      <Stack.Item grow>
        <Button
          fluid
          icon="brain"
          selected={upload_mode === MODE_AI}
          color={upload_mode === MODE_AI ? 'blue' : 'default'}
          onClick={() => act('set_mode', { mode: MODE_AI })}
        >
          Искусственный Интеллект
        </Button>
      </Stack.Item>
      <Stack.Item grow>
        <Button
          fluid
          icon="robot"
          selected={upload_mode === MODE_BORG}
          color={upload_mode === MODE_BORG ? 'teal' : 'default'}
          onClick={() => act('set_mode', { mode: MODE_BORG })}
        >
          Киборги
        </Button>
      </Stack.Item>
    </Stack>
  </Section>
);

// ─── Текущая цель ────────────────────────────────────────────────────────────

type TargetDisplayProps = {
  current_name: string | null;
  current_alive: boolean;
  act: Function;
};

const TargetDisplay = ({ current_name, current_alive, act }: TargetDisplayProps) => (
  <Section title="Выбранная цель">
    {current_name ? (
      <Stack align="center">
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item label="Цель">
              <Icon name={current_alive ? 'circle' : 'times-circle'} color={current_alive ? 'good' : 'bad'} mr={1} />
              {current_name}
            </LabeledList.Item>
            <LabeledList.Item label="Статус">
              <Box color={current_alive ? 'good' : 'bad'}>{current_alive ? 'В сети' : 'Не в сети / недоступен'}</Box>
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
        <Stack.Item>
          <Button icon="times" color="red" tooltip="Сбросить выбор" onClick={() => act('clear_target')} />
        </Stack.Item>
      </Stack>
    ) : (
      <Box color="label" italic>
        <Icon name="exclamation-triangle" mr={1} color="average" />
        Цель не выбрана — применение платы законов невозможно
      </Box>
    )}
  </Section>
);

// ─── Список целей ────────────────────────────────────────────────────────────

type TargetListProps = {
  upload_mode: number;
  ai_list: SiliconTarget[];
  borg_list: SiliconTarget[];
  current_uid: number | null;
  act: Function;
};

const TargetList = ({ upload_mode, ai_list, borg_list, current_uid, act }: TargetListProps) => {
  const list = upload_mode === MODE_AI ? ai_list : borg_list;
  const label = upload_mode === MODE_AI ? 'Доступные ИИ' : 'Доступные киборги';
  const icon = upload_mode === MODE_AI ? 'brain' : 'robot';
  const accentColor = upload_mode === MODE_AI ? 'blue' : 'teal';

  return (
    <Section title={label} fill scrollable>
      {list.length === 0 ? (
        <Box color="label" italic textAlign="center" mt={2}>
          <Icon name={icon} mr={1} />
          {upload_mode === MODE_AI ? 'Нет доступных ИИ на этом уровне' : 'Нет доступных боргов на этом уровне'}
        </Box>
      ) : (
        <Stack vertical>
          {list.map((target) => (
            <Stack.Item key={target.uid}>
              <Button
                fluid
                icon={target.alive ? icon : 'times-circle'}
                color={current_uid === target.uid ? accentColor : target.alive ? 'default' : 'bad'}
                selected={current_uid === target.uid}
                disabled={!target.alive}
                tooltip={
                  !target.alive
                    ? 'Недоступен: не в сети или повреждён'
                    : current_uid === target.uid
                      ? 'Выбрано'
                      : 'Выбрать цель'
                }
                onClick={() => target.alive && act('select_target', { uid: target.uid })}
              >
                <Stack align="center">
                  <Stack.Item grow>{target.name}</Stack.Item>
                  <Stack.Item>
                    <Box as="span" fontSize="0.8em" color={target.alive ? 'good' : 'bad'}>
                      {target.alive ? '● в сети' : '✕ офлайн'}
                    </Box>
                  </Stack.Item>
                </Stack>
              </Button>
            </Stack.Item>
          ))}
        </Stack>
      )}
    </Section>
  );
};
