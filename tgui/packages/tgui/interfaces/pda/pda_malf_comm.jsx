import { useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Input,
  LabeledList,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';

import { useBackend } from '../../backend';

export const pda_malf_comm = (props) => {
  const { act, data } = useBackend();
  const {
    ai_name, current_alert, alert_levels,
    esc_callable, esc_recallable, esc_status, lastCallLoc,
    possible_cc_sounds, stat_display,
  } = data;

  const [showAnnounce, setShowAnnounce] = useState(false);
  const [showStatus, setShowStatus] = useState(false);
  const [silentNuke, setSilentNuke] = useState(false);

  const [announceData, setAnnounceData] = useState({
    subtitle: `Отчёт от ${ai_name || 'Nexus'}`,
    title: 'Nexus Broadcast',
    text: '',
    beepsound: 'Beep',
    classified: 0,
  });

  // --- ЭКРАН СТАТУС-ДИСПЛЕЕВ ---
  if (showStatus) {
    const presetButtons = stat_display.presets.map((pb) => (
      <Button
        key={pb.name}
        content={pb.label}
        selected={pb.name === stat_display.type}
        tooltip={pb.desc}
        onClick={() => act('setstat', { statdisp: pb.name })}
      />
    ));

    const iconButtons = stat_display.alerts.map((ib) => (
      <Button
        key={ib.alert}
        content={ib.label}
        selected={ib.alert === stat_display.icon}
        tooltip={ib.desc}
        onClick={() => act('setstat', { statdisp: 3, alert: ib.alert })}
      />
    ));

    return (
      <Stack fill vertical>
        <Stack.Item>
          <Section
            title="Modify Status Screens"
            buttons={<Button icon="arrow-circle-left" content="Back to Nexus" onClick={() => setShowStatus(false)} />}
          >
            <LabeledList>
              <LabeledList.Item label="Presets">{presetButtons}</LabeledList.Item>
              <LabeledList.Item label="Alerts">{iconButtons}</LabeledList.Item>
              <LabeledList.Item label="Message Line 1">
                <Button icon="pencil-alt" content={stat_display.line_1} onClick={() => act('setmsg1')} />
              </LabeledList.Item>
              <LabeledList.Item label="Message Line 2">
                <Button icon="pencil-alt" content={stat_display.line_2} onClick={() => act('setmsg2')} />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Stack.Item>
      </Stack>
    );
  }

  // --- ЭКРАН АНОНСОВ ---
  if (showAnnounce) {
    return (
      <Stack fill vertical>
        <Stack.Item>
          <Section
            title="Nexus Broadcast Protocol"
            buttons={
              <Button
                icon="arrow-circle-left"
                content="Back to Nexus"
                onClick={() => setShowAnnounce(false)}
              />
            }
          >
            <Stack fill vertical>
              <Stack.Item>
                <Input fluid placeholder="From (Большой белый заголовок)..." value={announceData.subtitle} onChange={(value) => setAnnounceData({ ...announceData, subtitle: value })} />
              </Stack.Item>
              <Stack.Item>
                <Input fluid placeholder="Topic (Меньший белый заголовок)..." value={announceData.title} onChange={(value) => setAnnounceData({ ...announceData, title: value })} />
              </Stack.Item>
              <Stack.Item>
                <TextArea fluid height="120px" placeholder="Enter Announcement text here (Red small font)..." value={announceData.text} onChange={(value) => setAnnounceData({ ...announceData, text: value })} />
              </Stack.Item>
              <Stack.Item>
                <Stack align="center">
                  <Stack.Item grow>
                    <Dropdown options={possible_cc_sounds || ["Beep"]} selected={announceData.beepsound} onSelected={(val) => setAnnounceData({ ...announceData, beepsound: val })} disabled={announceData.classified} />
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="volume-up" disabled={announceData.classified} tooltip="Test sound locally" onClick={() => act('test_sound', { sound: announceData.beepsound })} />
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Checkbox fluid checked={announceData.classified} tooltip={announceData.classified ? 'Sent to station communications consoles' : 'Publically announced'} onClick={() => setAnnounceData({ ...announceData, classified: announceData.classified ? 0 : 1 })}>
                      Classified
                    </Button.Checkbox>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item>
                <Button fluid icon="paper-plane" textAlign="center" color="good" disabled={announceData.text.length < 6} onClick={() => {
                  act('make_cc_announcement', { subtitle: announceData.subtitle, title: announceData.title, text: announceData.text, beepsound: announceData.beepsound, classified: announceData.classified });
                  setAnnounceData({ subtitle: `Отчёт от ${ai_name || 'Nexus'}`, title: 'Nexus Broadcast', text: '', beepsound: 'Beep', classified: 0 });
                  setShowAnnounce(false);
                }}>
                  Send Nexus Broadcast
                </Button>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
      </Stack>
    );
  }

  // --- ГЛАВНЫЙ ЭКРАН НЕКСУСА ---
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
            {esc_status && (
              <LabeledList.Item label="Status">
                {esc_status}
              </LabeledList.Item>
            )}
            <LabeledList.Item label="Options">
              {esc_recallable ? (
                <Button icon="times" content="Recall Shuttle" onClick={() => act('cancelshuttle')} />
              ) : (
                <Button icon="rocket" content="Call Shuttle" disabled={!esc_callable} onClick={() => act('callshuttle')} />
              )}
            </LabeledList.Item>
            {lastCallLoc && (
              <LabeledList.Item label="Last Call/Recall From">
                {lastCallLoc}
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
      </Stack.Item>

      {/* 3. Nexus Command */}
      <Stack.Item>
        <Section title="Nexus Command">
          <LabeledList>
            <LabeledList.Item label="Current Security Level">
              <Box color={data.current_level_color || "red"}>
                {data.current_level_name || "Unknown"}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Override Security Level">
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
            <LabeledList.Item label="Broadcast">
              <Button icon="bullhorn" content="Initiate Broadcast Protocol" onClick={() => setShowAnnounce(true)} />
            </LabeledList.Item>
            <LabeledList.Item label="Transmit">
              <Button icon="broadcast-tower" content="Message CentComm" onClick={() => act('MessageCentcomm')} />
            </LabeledList.Item>
            <LabeledList.Item label="Nuclear Device">
              <Stack align="center">
                <Stack.Item>
                  <Button
                    icon="bomb"
                    content="Request Authentication Codes"
                    onClick={() => act('nukerequest', { silent: silentNuke ? "1" : "0" })}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Checkbox
                    checked={silentNuke}
                    tooltip="Do not announce the request to the station"
                    onClick={() => setSilentNuke(!silentNuke)}
                  >
                    Silent
                  </Button.Checkbox>
                </Stack.Item>
              </Stack>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>

      {/* 4. Station Systems */}
      <Stack.Item>
        <Section title="Station Systems">
          <LabeledList>
            <LabeledList.Item label="Displays">
              <Button icon="tv" content="Change Status Displays" onClick={() => setShowStatus(true)} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
