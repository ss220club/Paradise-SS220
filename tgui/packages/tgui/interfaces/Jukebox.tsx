import { sortBy } from 'common/collections';
import { flow } from 'common/fp';

import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import {
  Box,
  Button,
  Knob,
  ProgressBar,
  Section,
  Stack,
  Dimmer,
  Icon,
} from '../components';
import { Window } from '../layouts';

type Song = {
  name: string;
  length: number;
  beat: number;
};

type Data = {
  active: BooleanLike;
  looping: BooleanLike;
  need_coin: BooleanLike;
  volume: number;
  startTime: number;
  endTime: number;
  worldTime: number;
  track_selected: string | null;
  payment: string | null;
  songs: Song[];
};

export const Jukebox = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const {
    active,
    looping,
    track_selected,
    volume,
    songs,
    startTime,
    endTime,
    worldTime,
    need_coin,
  } = data;

  const songs_sorted: Song[] = flow([sortBy((song: Song) => song.name)])(songs);
  const song_selected: Song | undefined = songs.find(
    (song) => song.name === track_selected
  );

  const formatTime = (seconds) => {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;
    const formattedTime = `${String(minutes).padStart(2, '0')}:${String(remainingSeconds).padStart(2, '0')}`;
    return formattedTime;
  };

  const trackTimer = (
    <Box textAlign="center">
      {active
        ? looping
          ? '∞'
          : formatTime(Math.round((worldTime - startTime) / 10))
        : looping
          ? '∞'
          : formatTime(song_selected.length)}{' '}
      / {looping ? '∞' : formatTime(song_selected.length)}
    </Box>
  );

  return (
    <Window width={350} height={435} title="Музыкальный автомат">
      <NoCoin />
      <Window.Content>
        <Stack fill vertical>
          <Stack>
            <Stack.Item grow textAlign="center">
              <Section fill title="Проигрыватель">
                <Stack fill vertical>
                  <Stack.Item grow>
                    <Box bold>{song_selected.name}</Box>
                  </Stack.Item>
                  <Stack fill mt={1.5}>
                    <Stack.Item grow basis="0">
                      <Button
                        fluid
                        icon={active ? 'pause' : 'play'}
                        color="transparent"
                        content={active ? 'Стоп' : 'Старт'}
                        selected={active}
                        onClick={() => act('toggle')}
                      />
                    </Stack.Item>
                    <Stack.Item grow basis="0">
                      <Button.Checkbox
                        fluid
                        icon={'undo'}
                        content="Повтор"
                        disabled={active || need_coin}
                        tooltip={
                          need_coin
                            ? 'Вы не можете включить повтор за монетку'
                            : null
                        }
                        checked={looping}
                        onClick={() => act('loop', { looping: !looping })}
                      />
                    </Stack.Item>
                  </Stack>
                  <Stack.Item>
                    <ProgressBar.Countdown
                      start={startTime}
                      current={!looping ? worldTime : endTime}
                      end={endTime}
                    >
                      {trackTimer}
                    </ProgressBar.Countdown>
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Section>
                <OnMusic />
                <Stack fill mb={1.5}>
                  <Stack.Item grow m={0}>
                    <Button
                      fluid
                      color="transparent"
                      icon="fast-backward"
                      onClick={() =>
                        act('set_volume', {
                          volume: 'min',
                        })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item m={0}>
                    <Button
                      fluid
                      color="transparent"
                      icon="undo"
                      onClick={() =>
                        act('set_volume', {
                          volume: 'reset',
                        })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item grow m={0} textAlign="right">
                    <Button
                      fluid
                      color="transparent"
                      icon="fast-forward"
                      onClick={() =>
                        act('set_volume', {
                          volume: 'max',
                        })
                      }
                    />
                  </Stack.Item>
                </Stack>
                <Box position="relative" textAlign="center" textColor="label">
                  <Knob
                    mr={1}
                    ml={1}
                    size={2}
                    color={
                      volume <= 25
                        ? 'green'
                        : volume <= 50
                          ? ''
                          : volume <= 75
                            ? 'orange'
                            : 'red'
                    }
                    value={volume}
                    unit="%"
                    minValue={0}
                    maxValue={100}
                    step={1}
                    stepPixelSize={5}
                    onDrag={(e, value) =>
                      act('set_volume', {
                        volume: value,
                      })
                    }
                  />
                  Volume
                </Box>
              </Section>
            </Stack.Item>
          </Stack>
          <Stack.Item grow textAlign="center">
            <Section fill scrollable title="Доступные треки">
              {songs_sorted.map((song) => (
                <Stack.Item key={song.name} mb={0.5} textAlign="left">
                  <Button
                    fluid
                    selected={song_selected.name === song.name}
                    color="translucent"
                    content={song.name}
                    onClick={() => {
                      act('select_track', { track: song.name });
                    }}
                  />
                </Stack.Item>
              ))}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const OnMusic = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { active } = data;

  return active ? (
    <Dimmer textAlign="center">
      <Icon name="music" size="3" color="gray" mr={1} />
      <Box color="label" bold mt={1}>
        Играет музыка
      </Box>
    </Dimmer>
  ) : null;
};

const NoCoin = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { payment, need_coin } = data;

  return !payment && need_coin ? (
    <Dimmer textAlign="center">
      <Icon name="coins" size="6" color="gold" mr={1} />
      <Box color="label" bold mt={5} fontSize={2}>
        Вставьте монетку
      </Box>
    </Dimmer>
  ) : null;
};
