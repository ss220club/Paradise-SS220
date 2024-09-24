import { useBackend, useLocalState } from '../backend';
import { Button, DmIcon, LabeledList, Section, Table, Dropdown, Flex, Icon, Box } from '../components';
import { Window } from '../layouts';

const SelectableTile = (props, context) => {
  const { act, data } = useBackend(context);
  const { icon_state, dir, isSelected, onSelect } = props;
  return (
    <DmIcon
      icon={data.icon}
      icon_state={icon_state}
      direction={dir}
      onClick={onSelect}
      style={{
        'border-style': (isSelected && 'solid') || 'none',
        'border-width': '2px',
        'border-color': 'orange',
        padding: (isSelected && '2px') || '4px',
      }}
    />
  );
};

const dirToNum = (dir) => {
  switch (dir) {
    case 'north':
      return 1;
    case 'south':
      return 2;
    case 'east':
      return 4;
    case 'west':
      return 8;
    case 'northeast':
      return 1 | 4;
    case 'northwest':
      return 1 | 8;
    case 'southeast':
      return 2 | 4;
    case 'southwest':
      return 2 | 8;
    default:
      return 2;
  }
};

export const FloorPainter = (props, context) => {
  const { act, data } = useBackend(context);
  const { availableStyles, selectedStyle, selectedDir } = data;
  return (
    <Window width={405} height={475}>
      <Window.Content scrollable>
        <Section title="Decal setup">
          <Flex>
            <Flex.Item>
              <Button icon="chevron-left" onClick={() => act('cycle_style', { offset: -1 })} />
            </Flex.Item>
            <Flex.Item>
              <Dropdown
                options={availableStyles}
                selected={selectedStyle}
                width="150px"
                height="20px"
                ml="2px"
                mr="2px"
                nochevron
                onSelected={(val) => act('select_style', { style: val })}
              />
            </Flex.Item>
            <Flex.Item>
              <Button icon="chevron-right" onClick={() => act('cycle_style', { offset: 1 })} />
            </Flex.Item>
          </Flex>

          <Box mt="5px" mb="5px">
            <Flex
              overflowY="auto" // scroll
              maxHeight="220px" // a bit more than half of all tiles fit in this box at once.
              wrap="wrap"
            >
              {availableStyles.map((style) => (
                <Flex.Item key="{style}">
                  <SelectableTile
                    icon_state={style}
                    isSelected={selectedStyle === style}
                    onSelect={() => act('select_style', { style: style })}
                  />
                </Flex.Item>
              ))}
            </Flex>
          </Box>

          <LabeledList>
            <LabeledList.Item label="Direction">
              <Table style={{ display: 'inline' }}>
                {['north', '', 'south'].map((latitude) => (
                  <Table.Row key={latitude}>
                    {[latitude + 'west', latitude, latitude + 'east'].map((dir) => (
                      <Table.Cell
                        key={dir}
                        style={{
                          'vertical-align': 'middle',
                          'text-align': 'center',
                        }}
                      >
                        {dir === '' ? (
                          <Icon name="arrows-alt" size={3} />
                        ) : (
                          <SelectableTile
                            icon_state={selectedStyle}
                            dir={dirToNum(dir)}
                            isSelected={dir === selectedDir}
                            onSelect={() => act('select_direction', { direction: dir })}
                          />
                        )}
                      </Table.Cell>
                    ))}
                  </Table.Row>
                ))}
              </Table>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
