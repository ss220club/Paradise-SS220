import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../../backend';

export const pda_ai_comm = (props) => {
  const { act, data } = useBackend();
  const { ai_name, current_alert, alert_levels, esc_callable, esc_recallable, esc_status } = data;

  return (
    <Stack fill vertical>
      {/* 1. Authentication */}
      <Stack.Item>
        <Section title="Authentication">
          <LabeledList>
            <LabeledList.Item label="Actions">
              <Button icon="id-card" content="Log In" disabled />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>

      {/* 2. Escape Shuttle */}
      <Stack.Item>
        <Section title="Escape Shuttle">
          <LabeledList>
            {esc_status && <LabeledList.Item label="Status">{esc_status}</LabeledList.Item>}
            <LabeledList.Item label="Options">
              {esc_recallable ? (
                <Button icon="times" content="Recall Shuttle" onClick={() => act('cancelshuttle')} />
              ) : (
                <Button icon="rocket" content="Call Shuttle" disabled={!esc_callable} onClick={() => act('callshuttle')} />
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>

      {/* 3. Command Actions */}
      <Stack.Item>
        <Section title="Command Actions">
          <LabeledList>
            <LabeledList.Item label="Current Security Level">
              <Box color={data.current_level_color || "red"}>
                {data.current_level_name || "Unknown"}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Change Security Level">
              <Box>
                {alert_levels && alert_levels.map((slevel) => (
                  <Button
                    key={slevel.id}
                    icon={slevel.icon}
                    content={slevel.name}
                    selected={slevel.id === current_alert}
                    disabled={slevel.id === current_alert}
                    onClick={() => act('newalertlevel', { level: slevel.id })}
                  />
                ))}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Announcement">
              <Button
                icon="bullhorn"
                content="Make Station Announcement"
                onClick={() => act('ai_announce')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Transmit">
              <Button
                icon="broadcast-tower"
                content="Message CentComm"
                onClick={() => act('MessageCentcomm')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
