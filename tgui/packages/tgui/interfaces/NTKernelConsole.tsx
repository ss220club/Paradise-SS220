import { Box, Button, Icon, Section, Stack } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export const NTKernelConsole = () => {
  const { act, data } = useBackend();
  const { card_inserted, card_name, authorizing, authorized } = data;

  if (authorized) {
    return (
      <Window title="NT Operating System Kernel" width={500} height={400} theme="ntos">
        <Window.Content className="NTKernel__matrixBg">
          <MainMenu act={act} />
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window title="NT Operating System Kernel" width={500} height={400} theme="ntos">
      <Window.Content className="NTKernel__matrixBg">
        <Stack fill vertical align="center" justify="center">
          <Stack.Item>
            <Box fontSize="2.2em" bold color="white" textAlign="center" className="NTKernel__glow">
              NT OPERATING SYSTEM KERNEL
            </Box>
          </Stack.Item>
          <Stack.Item mt={4}>
            <Section>
              <Stack align="center">
                <Stack.Item width="200px">
                  {card_inserted ? (
                    <Box color="good">
                      <Icon name="id-card" mr={1} />
                      {card_name}
                    </Box>
                  ) : (
                    <Box color="label" italic>
                      Ключ доступа не обнаружен
                    </Box>
                  )}
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon={card_inserted ? 'eject' : 'id-card'}
                    tooltip={card_inserted ? 'Извлечь перфокарту' : 'Вставьте перфокарту'}
                    disabled={!card_inserted}
                    onClick={() => act('eject_card')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    content={authorizing ? 'Проверка ключей...' : 'Авторизация'}
                    icon={authorizing ? 'spinner' : 'unlock'}
                    iconSpin={authorizing}
                    disabled={!card_inserted || authorizing}
                    color="good"
                    onClick={() => act('authorize')}
                  />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

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
