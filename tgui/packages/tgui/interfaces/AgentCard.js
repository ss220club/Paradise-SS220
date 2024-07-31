import { useBackend, useLocalState, useSharedState } from '../backend';
import { Button, NoticeBox, LabeledList, Section, Tabs, ImageButton, Stack } from '../components';
import { ImageButtonItem } from '../components/ImageButton';
import { Window } from '../layouts';

export const AgentCard = (props, context) => {
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);
  const decideTab = (index) => {
    switch (index) {
      case 0:
        return <AgentCardInfo />;
      case 1:
        return <AgentCardAppearances />;
      default:
        return <AgentCardInfo />;
    }
  };

  return (
    <Window width={405} height={505} theme="syndicate">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item textAlign="center">
            <Tabs fluid>
              <Tabs.Tab
                ml={1}
                mr={0.5}
                key="Card Info"
                icon="table"
                selected={0 === tabIndex}
                onClick={() => setTabIndex(0)}
              >
                Информация
              </Tabs.Tab>
              <Tabs.Tab
                ml={0.5}
                mr={1}
                key="Appearance"
                icon="id-card"
                selected={1 === tabIndex}
                onClick={() => setTabIndex(1)}
              >
                Внешний вид
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          {decideTab(tabIndex)}
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const AgentCardInfo = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    registered_name,
    sex,
    age,
    assignment,
    associated_account_number,
    blood_type,
    dna_hash,
    fingerprint_hash,
    photo,
    ai_tracking,
  } = data;
  const unset = 'Пусто';

  return (
    <>
      <Stack.Item>
        <NoticeBox m={0}>Изменения информации не влияют на доступы.</NoticeBox>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable title="Информация">
          <LabeledList>
            <LabeledList.Item label="Имя">
              <Button content={registered_name ? registered_name : unset} onClick={() => act('change_name')} />
            </LabeledList.Item>
            <LabeledList.Item label="Пол">
              <Button iconRight={false} content={sex ? sex : unset} onClick={() => act('change_sex')} />
            </LabeledList.Item>
            <LabeledList.Item label="Возраст">
              <Button content={age ? age : unset} onClick={() => act('change_age')} />
            </LabeledList.Item>
            <LabeledList.Item label="Должность">
              <Button content={assignment ? assignment : unset} onClick={() => act('change_occupation')} />
            </LabeledList.Item>
            <LabeledList.Item label="Отпечатки">
              <Button
                content={fingerprint_hash ? fingerprint_hash : unset}
                onClick={() => act('change_fingerprints')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Тип крови">
              <Button content={blood_type ? blood_type : unset} onClick={() => act('change_blood_type')} />
            </LabeledList.Item>
            <LabeledList.Item label="ДНК">
              <Button content={dna_hash ? dna_hash : unset} onClick={() => act('change_dna_hash')} />
            </LabeledList.Item>
            <LabeledList.Item label="Банковский счёт">
              <Button
                content={associated_account_number ? associated_account_number : unset}
                onClick={() => act('change_money_account')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Фото">
              <Button content={photo ? 'Update' : unset} onClick={() => act('change_photo')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section fill title="Настройки карты">
          <LabeledList>
            <LabeledList.Item label="Информация">
              <Button.Confirm
                content="Удалить всю информацию"
                confirmContent="Вы уверены?"
                onClick={() => act('delete_info')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Доступы">
              <Button.Confirm
                content="Сбросить доступы"
                confirmContent="Вы уверены?"
                onClick={() => act('clear_access')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Отслеживание ИИ">
              <Button content={ai_tracking ? 'Невозможно' : 'Возможно'} onClick={() => act('change_ai_tracking')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
    </>
  );
};

export const AgentCardAppearances = (props, context) => {
  const { act, data } = useBackend(context);
  const [selectedAppearance, setSelectedAppearance] = useSharedState(context, 'selectedAppearance', 'null');
  const { appearances } = data;
  return (
    <Stack.Item grow>
      <Section fill scrollable title="Внешний вид">
        {Object.entries(appearances).map((appearance_unit) => {
          const [name, image] = appearance_unit;
          return (
            <ImageButton
              m={0.5}
              vertical
              key={name}
              image={image}
              imageSize={'64px'}
              selected={selectedAppearance === name}
              onClick={() => {
                setSelectedAppearance(name);
                act('change_appearance', {
                  new_appearance: name,
                });
              }}
            />
          );
        })}
      </Section>
    </Stack.Item>
  );
};
