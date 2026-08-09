import { useEffect, useMemo, useRef, useState } from 'react';
import { Box, Button, Icon, ImageButton, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const NTKernelConsole = () => {
  const { act, data } = useBackend();
  const {
    card_inserted,
    card_icon,
    card_icon_state,
    authorizing,
    authorized,
    error_state,
    command_log,
    current_path,
    is_root,
    rebooting,
    mount_busy,
  } = data;

  let screen;
  if (authorized) {
    screen = (
      <TerminalScreen
        act={act}
        command_log={command_log}
        current_path={current_path}
        is_root={is_root}
        rebooting={rebooting}
        mount_busy={mount_busy}
      />
    );
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

  // На терминальном экране матрица/сетка не нужны — сразу чёрный CMD-фон
  const isTerminal = !!authorized;

  return (
    <Window title="NT Operating System Kernel" width={750} height={600} theme="ntos">
      <Window.Content
        className={
          isTerminal ? 'NTKernel__cmdBg' : 'NTKernel__matrixBg' + (error_state ? ' NTKernel__errorOverlay' : '')
        }
      >
        {!isTerminal && <div className="NTKernel__grid" />}
        {!isTerminal && <MatrixRain />}
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
          <Button content="Подключение" icon="sign-in-alt" color="good" onClick={() => act('authorize')} />
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

// ─── Терминал — единственный экран после авторизации, только команды ───────

const TerminalScreen = ({ act, command_log, current_path, is_root, rebooting, mount_busy }) => {
  const [inputValue, setInputValue] = useState('');
  const [history, setHistory] = useState([]);
  const [historyIndex, setHistoryIndex] = useState(-1);
  const clipboardRef = useRef('');
  const inputRef = useRef(null);
  const bodyRef = useRef(null);

  useEffect(() => {
    if (bodyRef.current) {
      bodyRef.current.scrollTop = bodyRef.current.scrollHeight;
    }
  }, [command_log]);

  const refocusInput = () => {
    inputRef.current?.focus();
  };

  const deferredRefocus = () => {
    setTimeout(refocusInput, 0);
  };

  const submit = () => {
    act('run_command', { command_text: inputValue });
    if (inputValue.trim()) {
      setHistory((h) => [...h, inputValue]);
    }
    setHistoryIndex(-1);
    setInputValue('');
  };

  const handleKeyDown = (e) => {
    if (e.key === 'Enter') {
      submit();
      return;
    }

    // История команд — вверх/вниз, а не хождение по буквам (это стрелки влево/вправо, native)
    if (e.key === 'ArrowUp') {
      e.preventDefault();
      if (history.length === 0) {
        return;
      }
      const nextIndex = historyIndex === -1 ? history.length - 1 : Math.max(0, historyIndex - 1);
      setHistoryIndex(nextIndex);
      setInputValue(history[nextIndex]);
      return;
    }
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      if (historyIndex === -1) {
        return;
      }
      const nextIndex = historyIndex + 1;
      if (nextIndex >= history.length) {
        setHistoryIndex(-1);
        setInputValue('');
      } else {
        setHistoryIndex(nextIndex);
        setInputValue(history[nextIndex]);
      }
      return;
    }

    const key = e.key.toLowerCase();

    // Ctrl+Shift+[C/X/V/A] — буфер, привязанный к самой консоли, а не к реальной ОС
    if (e.ctrlKey && e.shiftKey && ['c', 'x', 'v', 'a'].includes(key)) {
      e.preventDefault();
      const el = e.target;
      const start = el.selectionStart ?? 0;
      const end = el.selectionEnd ?? 0;
      if (key === 'c') {
        clipboardRef.current = inputValue.slice(start, end) || inputValue;
      } else if (key === 'x') {
        clipboardRef.current = inputValue.slice(start, end) || inputValue;
        setInputValue(inputValue.slice(0, start) + inputValue.slice(end));
      } else if (key === 'v') {
        setInputValue(inputValue.slice(0, start) + clipboardRef.current + inputValue.slice(end));
      } else if (key === 'a') {
        el.select();
      }
      return;
    }

    // Обычный Ctrl+C/V/X/A — в "умном" терминале это не копипаст, а служебные сочетания
    if (e.ctrlKey && !e.shiftKey && ['c', 'v', 'x', 'a'].includes(key)) {
      e.preventDefault();
      if (key === 'c') {
        setInputValue((v) => v + '^C');
      }
      return;
    }
  };

  return (
    <div className="NTKernel__cmdScreen" onClick={refocusInput}>
      <div className="NTKernel__cmdTitlebar" />
      <div className="NTKernel__cmdBody NTKernel__cmdBodyScrollable" ref={bodyRef}>
        <div className="NTKernel__cmdLine NTKernel__cmdText--output">
          NanoTrasen Systems [NSS Cyberiad Kernel Build 22631.6199]
        </div>
        <div className="NTKernel__cmdLine NTKernel__cmdLineSmall NTKernel__cmdText--desc">
          (c) NanoTrasen Corporation. All rights reserved.
        </div>
        <div className="NTKernel__cmdLine">&nbsp;</div>
        {(command_log || []).map((entry, i) => (
          <div key={i} className={'NTKernel__cmdLine NTKernel__cmdText--' + (entry.type || 'output')}>
            {entry.text}
          </div>
        ))}
        {!rebooting && !mount_busy && (
          <div className="NTKernel__cmdPromptLine">
            <span
              className={
                'NTKernel__cmdPromptCaret ' + (is_root ? 'NTKernel__cmdText--root' : 'NTKernel__cmdText--input')
              }
            >
              {(current_path || '/') + '...> '}
            </span>
            <input
              ref={inputRef}
              className="NTKernel__cmdInput"
              style={{ width: Math.max(inputValue.length, 1) + 'ch' }}
              value={inputValue}
              onChange={(e) => setInputValue(e.target.value)}
              onKeyDown={handleKeyDown}
              onBlur={deferredRefocus}
              autoFocus
              spellCheck={false}
            />
            <span className="NTKernel__cmdCursor" />
          </div>
        )}
      </div>
    </div>
  );
};
