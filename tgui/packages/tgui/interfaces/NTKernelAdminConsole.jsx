import { useMemo, useState } from 'react';
import { Box, Button, Icon, ImageButton, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const NTKernelAdminConsole = () => {
  const { act, data } = useBackend();
  const {
    card_inserted,
    card_icon,
    card_icon_state,
    authorizing,
    authorized,
    error_state,
    rebooting,
    reboot_phase,
    reboot_countdown,
    terminal_log,
  } = data;

  const isCmdPhase = rebooting && reboot_phase === 'executing';

  let screen;
  if (rebooting && reboot_phase === 'countdown') {
    screen = <RebootScreen reboot_countdown={reboot_countdown} />;
  } else if (authorized) {
    screen = <MainMenu act={act} data={data} />;
  } else if (error_state) {
    screen = <ErrorScreen />;
  } else if (authorizing) {
    screen = <LoadingScreen />;
  } else {
    screen = (
      <LoginScreen
        act={act}
        card_inserted={card_inserted}
        card_icon={card_icon}
        card_icon_state={card_icon_state}
      />
    );
  }

  const glitchTicks = [17, 11, 5];
  const isGlitchTick = reboot_phase === 'countdown' && glitchTicks.includes(reboot_countdown);

  return (
    <Window title="NT Operating System Kernel [CentComm Access]" width={500} height={400} theme="ntos">
      <Window.Content
        className={
          (isCmdPhase ? 'NTKernel__cmdBg' : 'NTKernel__matrixBg') +
          (error_state ? ' NTKernel__errorOverlay' : '') +
          (isGlitchTick ? ' NTKernel__glitch' : '')
        }
      >
        {!isCmdPhase && <div className="NTKernel__grid" />}
        {!isCmdPhase && <MatrixRain />}
        <div className="NTKernel__screenWrapper">{isCmdPhase ? <CMDScreen terminal_log={terminal_log} /> : screen}</div>
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

const LoginScreen = ({ act, card_inserted, card_icon, card_icon_state }) => (
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
    {!!card_inserted && (
      <>
        <Stack.Item mt={3}>
          <ImageButton
            className="NTKernel__cardSlot"
            dmIcon={card_icon}
            dmIconState={card_icon_state}
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

// ─── Экран протокола перезагрузки — отсчёт, затем исполнение ───────────────

// Чем ближе к нулю — тем краснее: плавный переход зелёный (120) -> жёлтый (60) -> красный (0)
const countdownColor = (value, total) => {
  const t = Math.max(0, Math.min(1, value / total));
  const hue = Math.round(120 * t);
  return `hsl(${hue}, 100%, 50%)`;
};

const REBOOT_COUNTDOWN_TOTAL = 20;

const RebootScreen = ({ reboot_countdown }) => (
  <Stack fill vertical align="center" justify="center">
    <Stack.Item>
      <Icon name="power-off" size={4} className="NTKernel__rebootGlow" />
    </Stack.Item>
    <Stack.Item mt={2}>
      <Box
        fontSize="3em"
        bold
        textAlign="center"
        className="NTKernel__rebootGlow"
        style={{ color: countdownColor(reboot_countdown, REBOOT_COUNTDOWN_TOTAL) }}
      >
        {reboot_countdown}
      </Box>
    </Stack.Item>
    <Stack.Item mt={2}>
      <Box fontSize="1.3em" bold textAlign="center" className="NTKernel__errorGlow NTKernel__pulse">
        ВНИМАНИЕ
        <br />
        ОТКЛЮЧЕНИЕ ВСЕХ СИСТЕМ
      </Box>
    </Stack.Item>
  </Stack>
);

// ─── CMD-экран — во время фазы "executing", пока все системы фактически лежат ──

const CMDScreen = ({ terminal_log }) => (
  <div className="NTKernel__cmdScreen">
    <div className="NTKernel__cmdTitlebar" />
    <div className="NTKernel__cmdBody">
      <div className="NTKernel__cmdLine">NanoTrasen Systems [NSS Cyberiad Kernel Build 22631.6199]</div>
      <div className="NTKernel__cmdLine NTKernel__cmdLineSmall">(c) NanoTrasen Corporation. All rights reserved.</div>
      <div className="NTKernel__cmdLine">&nbsp;</div>
      {(terminal_log || []).map((line, i) => (
        <div key={i} className="NTKernel__cmdLine">
          ...&gt; {line}
        </div>
      ))}
      <div className="NTKernel__cmdPromptLine">
        <span>...&gt;&nbsp;</span>
        <span className="NTKernel__cmdCursor" />
      </div>
    </div>
  </div>
);

// ─── Главное меню — доступ разрешён ─────────────────────────────────────────

const MainMenu = ({ act, data }) => {
  const { reboot_cooldown_remaining } = data;
  const onCooldown = reboot_cooldown_remaining > 0;
  const [confirmingReboot, setConfirmingReboot] = useState(false);

  const handleRebootClick = () => {
    if (!confirmingReboot) {
      setConfirmingReboot(true);
      return;
    }
    setConfirmingReboot(false);
    act('system_reboot');
  };

  return (
    <Stack fill vertical align="center" justify="center">
      <Stack.Item>
        <Box fontSize="1.4em" bold color="white" className="NTKernel__glow">
          ДОСТУП РАЗРЕШЁН -- ЦЕНТРАЛЬНОЕ КОМАНДОВАНИЕ
        </Box>
      </Stack.Item>
      <Stack.Item mt={3}>
        <Section>
          <Stack>
            <Stack.Item>
              <Button icon="brain" content="Управление модулями ИИ" onClick={() => act('open_ai_modules')} />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon={confirmingReboot ? undefined : 'power-off'}
                color="bad"
                content={confirmingReboot ? 'Подтверждаете?' : 'Перезагрузка систем'}
                disabled={onCooldown}
                tooltip={onCooldown ? `Доступно через ${reboot_cooldown_remaining} сек.` : undefined}
                onClick={handleRebootClick}
                onMouseLeave={() => setConfirmingReboot(false)}
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
};
