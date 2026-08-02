import { useMemo } from 'react';
import { Box, Button, Icon, ImageButton, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const NTKernelConsole = () => {
  const { act, data } = useBackend();
  const { card_inserted, card_name, card_icon, card_icon_state, authorizing, authorized, error_state } = data;

  let screen;
  if (authorized) {
    screen = <MainMenu act={act} />;
  } else if (error_state) {
    screen = <ErrorScreen />;
  } else if (authorizing) {
    screen = <LoadingScreen />;
  } else {
    screen = (
      <LoginScreen
        act={act}
        card_inserted={card_inserted}
        card_name={card_name}
        card_icon={card_icon}
        card_icon_state={card_icon_state}
      />
    );
  }

  return (
    <Window title="NT Operating System Kernel" width={500} height={400} theme="ntos">
      <Window.Content className={'NTKernel__matrixBg' + (error_state ? ' NTKernel__errorOverlay' : '')}>
        <div className="NTKernel__grid" />
        <MatrixRain />
        <div className="NTKernel__screenWrapper">{screen}</div>
      </Window.Content>
    </Window>
  );
};

// ─── Задник — падающие символы а-ля "Матрица" ───────────────────────────────

const MATRIX_CHARS = 'アカサタナハマヤャラワガザダバパイキシチニヒミリヰギジヂビピウクスツヌフムユュルグズブヅプエケセテネヘメレヱゲゼデベペオコソトノホモヨョロヲゴゾドボポヴッン0123456789'.split('');

const MATRIX_COLUMN_COUNT = 18;

const randomChar = () => MATRIX_CHARS[Math.floor(Math.random() * MATRIX_CHARS.length)];

const buildColumn = () => {
  const length = 12 + Math.floor(Math.random() * 10);
  return Array.from({ length }, randomChar).join('\n');
};

const MatrixRain = () => {
  const columns = useMemo(
    () =>
      Array.from({ length: MATRIX_COLUMN_COUNT }, (_, i) => ({
        key: i,
        left: (i / MATRIX_COLUMN_COUNT) * 100 + (Math.random() * 2 - 1),
        duration: (3.5 + Math.random() * 4) * 1.2,
        delay: Math.random() * -6,
        text: buildColumn(),
      })),
    []
  );

  return (
    <div className="NTKernel__matrixRain">
      {columns.map((col) => (
        <div
          key={col.key}
          className="NTKernel__matrixColumn"
          style={{
            left: col.left + '%',
            animationDuration: col.duration + 's',
            animationDelay: col.delay + 's',
          }}
        >
          {col.text}
        </div>
      ))}
    </div>
  );
};

// ─── Экран логина (карта не вставлена / вставлена, ожидание нажатия) ───────

const LoginScreen = ({ act, card_inserted, card_name, card_icon, card_icon_state }) => (
  <Stack fill vertical align="center" justify="center">
    <Stack.Item>
      <Box fontSize="2.2em" bold color="white" textAlign="center" className="NTKernel__glow">
        NT OPERATING SYSTEM KERNEL
      </Box>
    </Stack.Item>
    {!card_inserted && (
      <Stack.Item mt={2}>
        <Box fontSize="1em" color="label" textAlign="center" italic>
          Требуется ключ доступа
        </Box>
      </Stack.Item>
    )}
    {card_inserted && (
      <>
        <Stack.Item mt={3}>
          <ImageButton
            className="NTKernel__cardSlot"
            dmIcon={card_icon}
            dmIconState={card_icon_state}
            tooltip={`${card_name} — нажмите, чтобы извлечь`}
            onClick={() => act('eject_card')}
          />
        </Stack.Item>
        <Stack.Item mt={1}>
          <Button
            content="Подключение"
            icon="sign-in-alt"
            color="good"
            onClick={() => act('authorize')}
          />
        </Stack.Item>
      </>
    )}
  </Stack>
);

// ─── Экран загрузки — только по центру, ничего больше ──────────────────────

const LoadingScreen = () => (
  <Stack fill vertical align="center" justify="center">
    <Stack.Item>
      <Icon name="spinner" spin size={4} className="NTKernel__glow" color="good" />
    </Stack.Item>
    <Stack.Item mt={2}>
      <Box fontSize="1.1em" color="white" textAlign="center" className="NTKernel__glow">
        Проверка протоколов безопасности, ожидайте...
      </Box>
    </Stack.Item>
  </Stack>
);

// ─── Экран ошибки — карту выдернули во время загрузки ───────────────────────

const ErrorScreen = () => (
  <Stack fill vertical align="center" justify="center">
    <Stack.Item>
      <Icon name="exclamation-triangle" size={5} color="bad" className="NTKernel__errorGlow" />
    </Stack.Item>
    <Stack.Item mt={2}>
      <Box fontSize="1.2em" bold color="bad" textAlign="center" className="NTKernel__errorGlow">
        АВТОРИЗАЦИЯ ПРЕРВАНА
      </Box>
    </Stack.Item>
    <Stack.Item>
      <Box fontSize="0.9em" color="label" textAlign="center">
        Ключ доступа изъят из считывателя
      </Box>
    </Stack.Item>
  </Stack>
);

// ─── Главное меню — доступ разрешён ─────────────────────────────────────────

const MainMenu = ({ act }) => (
  <Stack fill vertical align="center" justify="center">
    <Stack.Item>
      <Box fontSize="1.4em" bold color="white" className="NTKernel__glow">
        ДОСТУП РАЗРЕШЁН
      </Box>
    </Stack.Item>
    <Stack.Item mt={3}>
      <Section>
        <Stack>
          <Stack.Item>
            <Button icon="brain" content="Управление модулями ИИ" onClick={() => act('open_ai_modules')} />
          </Stack.Item>
          <Stack.Item>
            <Button.Confirm
              icon="power-off"
              color="bad"
              content="Перезагрузка систем"
              onClick={() => act('system_reboot')}
            />
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
    <Stack.Item>
      <Button icon="sign-out-alt" content="Завершить сессию" onClick={() => act('logout')} />
    </Stack.Item>
  </Stack>
);
