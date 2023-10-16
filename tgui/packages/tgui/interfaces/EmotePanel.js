import { useBackend, useLocalState, useSharedState } from '../backend';
import { Window } from '../layouts';
import { Button, Section, Input, LabeledList } from '../components';

/*
type Emote = {
  key: string;
  emote_path: string;
  hands: BooleanLike;
  visible: BooleanLike;
  audible: BooleanLike;
  sound: BooleanLike;
};
*/

export const EmotePanelContent = (props, context) => {
  const { act, data } = useBackend(context);
  const { emotes } = data;

  const [searchText, setSearchText] = useLocalState(
    context,
    'searchText',
    ''
  );

  let searchBar = (
    <Input
      placeholder="Искать эмоцию..."
      fluid
      onInput={(e, value) => setSearchText(value)}
    />
  );

  return (
    <Section
      title={
        searchText.length > 0
          ? `Результаты поиска "${searchText}"`
          : `Все эмоции`
      }
      fill>
      <LabeledList vertical fill>
        <LabeledList.Item>
          <Section>
            {searchBar}
          </Section>
        </LabeledList.Item>
        <LabeledList.Item>
          {emotes.map((emote) =>
            emote.key ? (
              searchText.length > 0 ? (
                emote.key.toLowerCase().includes(searchText.toLowerCase()) ? (
                  <Button
                    key={emote.key}
                    onClick={() =>
                      act('play_emote', {
                        emote_path: emote.emote_path,
                      })
                    }>
                    {emote.key.toUpperCase()}
                  </Button>
                ) : (
                  ''
                )
              ) : (
                <Button
                  key={emote.key}
                  onClick={() =>
                    act('play_emote', {
                      emote_path: emote.emote_path,
                    })
                  }>
                  {emote.key.toUpperCase()}
                </Button>
              )
            ) : (
              ''
            )
          )}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const EmotePanel = (props, context) => {
  return (
    <Window width={500} height={450}>
      <Window.Content scrollable>
        <EmotePanelContent />
      </Window.Content>
    </Window>
  );
};
