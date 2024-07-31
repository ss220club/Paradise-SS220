import { useBackend, useLocalState, useSharedState } from '../backend';
import {
  Button,
  NoticeBox,
  LabeledList,
  Section,
  Tabs,
  ImageButton,
  Stack,
  Input,
  Slider,
  Dropdown,
} from '../components';
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
  const tooltipText = (
    <span>
      Автозаполнение.
      <br />
      ЛКМ - Ввести свой параметр.
      <br />
      ПКМ - Выбрать чужой параметр.
    </span>
  );
  const genders = [
    { name: 'Male', icon: 'mars' },
    { name: 'Female', icon: 'venus' },
    { name: 'Genderless', icon: 'genderless' },
  ];
  const bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  return (
    <>
      <Stack.Item>
        <NoticeBox m={0}>Изменения информации не влияют на доступы.</NoticeBox>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable title="Информация">
          <LabeledList>
            <LabeledList.Item label="Имя">
              <Stack fill mb={-0.5}>
                <Stack.Item grow>
                  <Button.Input
                    fluid
                    textAlign="center"
                    content={registered_name ? registered_name : unset}
                    onCommit={(e, value) =>
                      act('change_name', {
                        name: value,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="pen"
                    tooltip={tooltipText}
                    tooltipPosition={'bottom-end'}
                    onClick={() => act('change_name', { option: 'LMB' })}
                    onContextMenu={(event) => {
                      event.preventDefault();
                      act('change_name', { option: 'RMB' });
                    }}
                  />
                </Stack.Item>
              </Stack>
            </LabeledList.Item>
            <LabeledList.Item label="Пол">
              <Stack fill mb={-0.5}>
                {genders.map((gender) => (
                  <Stack.Item grow key={gender.name}>
                    <Button
                      fluid
                      icon={gender.icon}
                      content={gender.name}
                      selected={sex === gender.name}
                      onClick={() => act('change_sex', { sex: gender.name })}
                    />
                  </Stack.Item>
                ))}
              </Stack>
            </LabeledList.Item>
            <LabeledList.Item label="Возраст">
              <Slider
                fluid
                minValue={17}
                value={age ? age : 0}
                maxValue={300}
                onChange={(e, value) => act('change_age', { age: value })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Должность">
              <Button
                fluid
                textAlign="center"
                content={assignment ? assignment : unset}
                onClick={() => act('change_occupation')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Отпечатки">
              <Stack fill mb={-0.5}>
                <Stack.Item grow>
                  <Button.Input
                    fluid
                    textAlign="center"
                    content={fingerprint_hash ? fingerprint_hash : unset}
                    onCommit={(e, value) =>
                      act('change_fingerprints', {
                        new_fingerprints: value,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon={'pen'}
                    tooltip={'Ввести свои отпечатки.'}
                    tooltipPosition={'bottom-end'}
                    onClick={() => act('change_fingerprints', { option: 'Self' })}
                  />
                </Stack.Item>
              </Stack>
            </LabeledList.Item>
            <LabeledList.Item label="Тип крови">
              <Stack fill mb={-0.5}>
                <Stack.Item grow>
                  <Dropdown
                    width="100%"
                    options={bloodTypes}
                    displayText={blood_type}
                    onSelected={(val) => act('change_blood_type', { new_type: val })}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon={'pen'}
                    tooltip={'Выбрать свой тип крови.'}
                    tooltipPosition={'bottom-end'}
                    onClick={() => act('change_blood_type', { option: 'Self' })}
                  />
                </Stack.Item>
              </Stack>
            </LabeledList.Item>
            <LabeledList.Item label="ДНК">
              <Stack fill mb={-0.5}>
                <Stack.Item grow>
                  <Button.Input
                    fluid
                    textAlign="center"
                    content={dna_hash ? dna_hash : unset}
                    onCommit={(e, value) =>
                      act('change_dna_hash', {
                        new_dna: value,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon={'pen'}
                    tooltip={'Ввести своё ДНК.'}
                    tooltipPosition={'bottom-end'}
                    onClick={() => act('change_dna_hash', { option: 'Self' })}
                  />
                </Stack.Item>
              </Stack>
            </LabeledList.Item>
            <LabeledList.Item label="Аккаунт">
              <Slider
                fluid
                minValue={1000000}
                value={associated_account_number ? associated_account_number : 0}
                maxValue={9999999}
                content={associated_account_number ? associated_account_number : unset}
                onChange={(e, value) => act('change_money_account', { new_account: value })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Фото">
              <Button fluid textAlign="center" content={photo ? 'Update' : unset} onClick={() => act('change_photo')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section fill title="Настройки карты">
          <LabeledList>
            <LabeledList.Item label="Информация">
              <Button.Confirm
                fluid
                textAlign="center"
                content="Удалить всю информацию"
                confirmContent="Вы уверены?"
                onClick={() => act('delete_info')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Доступы">
              <Button.Confirm
                fluid
                textAlign="center"
                content="Сбросить доступы"
                confirmContent="Вы уверены?"
                onClick={() => act('clear_access')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Отслеживание ИИ">
              <Button
                fluid
                textAlign="center"
                content={ai_tracking ? 'Невозможно' : 'Возможно'}
                onClick={() => act('change_ai_tracking')}
              />
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
