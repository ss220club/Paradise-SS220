import { useBackend } from '../../backend';
import { Button, Icon, Stack, LabeledList, Section, Box } from '../../components';
import { BooleanLike } from 'common/react';

export const pda_main_menu220 = (props, context) => {
  const { act, data } = useBackend(context);

  const { owner, ownjob, idInserted, categories, pai, notifying } = data;

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section>
          <Stack>
            <LabeledList>
              <LabeledList.Item label="Owner" color="average">
                {owner}, {ownjob}
              </LabeledList.Item>
              <LabeledList.Item label="ID">
                <Button
                  icon="sync"
                  content="Update PDA Info"
                  disabled={!idInserted}
                  onClick={() => act('UpdateInfo')}
                />
              </LabeledList.Item>
            </LabeledList>
            <Button color="red" p={0.5} tooltip="Call Security to the area" onClick={() => act('security')}>
              <Stack vertical fill inline>
                <Stack.Item grow align="center">
                  <Icon name="exclamation-triangle" size={2} m={0} />
                </Stack.Item>
                <Stack.Item m={0}>
                  <Box fontSize={0.7} lineHeight={1} bold>
                    SECURITY
                  </Box>
                </Stack.Item>
              </Stack>
            </Button>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="Functions">
          <LabeledList>
            {categories.map((name) => {
              let apps = data.apps[name];

              if (!apps || !apps.length) {
                return null;
              } else {
                return (
                  <LabeledList.Item label={name} key={name}>
                    {apps.map((app) => (
                      <Button
                        key={app.uid}
                        icon={app.uid in notifying ? app.notifyingIcon : app.icon}
                        iconSpin={app.uid in notifying}
                        color={app.uid in notifying ? 'red' : 'transparent'}
                        content={app.name}
                        onClick={() => act('StartProgram', { program: app.uid })}
                      />
                    ))}
                  </LabeledList.Item>
                );
              }
            })}
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item>
        {!!pai && (
          <Section title="pAI">
            <Button fluid icon="cog" content="Configuration" onClick={() => act('pai', { option: 1 })} />
            <Button fluid icon="eject" content="Eject pAI" onClick={() => act('pai', { option: 2 })} />
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};
