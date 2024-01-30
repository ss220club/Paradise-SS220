import { sortBy } from 'common/collections';
import { flow } from 'common/fp';

import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dropdown,
  Knob,
  LabeledControls,
  LabeledList,
  Section,
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
  volume: number;
  track_selected: string | null;
  songs: Song[];
};

export const Jukebox = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { active, looping, track_selected, volume, songs } = data;

  const songs_sorted: Song[] = flow([sortBy((song: Song) => song.name)])(songs);
  const song_selected: Song | undefined = songs.find(
    (song) => song.name === track_selected
  );

  return (
    <Window width={370} height={314} title="Музыкальный автомат">
      <Window.Content>
        <Section
          title="Проигрыватель"
          buttons={
            <>
              <Button
                icon={active ? 'pause' : 'play'}
                color="transparent"
                content={active ? 'Стоп' : 'Старт'}
                selected={active}
                onClick={() => act('toggle')}
              />
              <Button.Checkbox
                icon={'undo'}
                content="Повтор"
                disabled={active}
                checked={looping}
                onClick={() => act('loop', { looping: !looping })}
              />
            </>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Выбранный трек">
              <Dropdown
                width="225px"
                options={songs_sorted.map((song) => song.name)}
                disabled={!!active}
                selected={song_selected?.name || 'Select a Track'}
                onSelected={(value) =>
                  act('select_track', {
                    track: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Длина трека">
              {song_selected?.length || 'Трек не выбран'}
            </LabeledList.Item>
            <LabeledList.Item label="Бит трека">
              {song_selected?.beat || 'Трек не выбран'}
              {song_selected?.beat === 1 ? ' бит' : ' бита'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Параметры">
          <LabeledControls justify="center">
            <LabeledControls.Item label="Volume">
              <Box position="relative">
                <Knob
                  size={3.2}
                  color={volume >= 25 ? 'red' : 'green'}
                  value={volume}
                  unit="%"
                  minValue={0}
                  maxValue={100}
                  step={1}
                  stepPixelSize={5}
                  disabled={active}
                  onDrag={(e, value) =>
                    act('set_volume', {
                      volume: value,
                    })
                  }
                />
                <Button
                  fluid
                  position="absolute"
                  top="-2px"
                  right="-22px"
                  color="transparent"
                  icon="fast-backward"
                  onClick={() =>
                    act('set_volume', {
                      volume: 'min',
                    })
                  }
                />
                <Button
                  fluid
                  position="absolute"
                  top="16px"
                  right="-22px"
                  color="transparent"
                  icon="fast-forward"
                  onClick={() =>
                    act('set_volume', {
                      volume: 'max',
                    })
                  }
                />
                <Button
                  fluid
                  position="absolute"
                  top="34px"
                  right="-22px"
                  color="transparent"
                  icon="undo"
                  onClick={() =>
                    act('set_volume', {
                      volume: 'reset',
                    })
                  }
                />
              </Box>
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
