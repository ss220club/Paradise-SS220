import { useBackend } from '../backend';
import { Button, LabeledList, Section, Box, Flex, NoticeBox } from "../components";
import { Window } from '../layouts';
import { sortBy } from "common/collections";
import { FlexItem } from '../components/Flex';

String.prototype.trimLongStr = function (length) {
  return this.length > length ? this.substring(0, length) + "..." : this;
};

export const Photocopier220 = (props, context) => {
  const { act, data } = useBackend(context);
  if (!data.isAI) {
    act("aipic");
  }

  const forms = sortBy(form => form.category)(data.forms || []);

  const categories = [];
  for (let form of forms) {
    if (!categories.includes(form.category)) {
      categories.push(form.category);
    }
  }

  let category;
  if (data.category === "") {
    category = forms;
  } else {
    category = forms.filter(form => form.category === data.category);
  }

  return (
    <Window theme={data.ui_theme}>
      <Window.Content scrollable>
        <Flex
          direction="row"
          spacing={1}>
          <Flex.Item
            width={24}
            shrink={0}>
            <Section
              title="Статус">
              <Flex>
                <Flex.Item mr="20px" color="grey">
                  Заряд тонера:
                </Flex.Item>
                <Flex.Item mr="5px" color={data.toner > 0 ? "good" : "bad"} bold>
                  {data.toner}
                </Flex.Item>
                </Flex>
                <Flex>
                  <Flex.Item width="100%" mt="8px">
                    <Button
                      fluid
                      textAlign="center"
                      disabled={!data.copyitem && !data.mob}
                      content={
                        data.copyitem
                          ? data.copyitem
                          : data.mob
                          ? "Жопа " + data.mob + "!"
                          : 'Слот для документа'
                      }
                      onClick={() => act('removedocument')}
                  />
                  </Flex.Item>
                  </Flex>
                  <Flex>
                  <Flex.Item width="100%"mt="3px">
                  <Button
                    fluid
                    textAlign="center"
                    disabled={!data.folder}
                    content={data.folder ? data.folder : 'Слот для папки'}
                    onClick={() => act('removefolder')}
                  />
                  </Flex.Item>
                  </Flex>
            </Section>
            <Section
              title="Управление">
                <Flex>
                  <Flex.Item width="30%" mr="3px">
                  <Button
                    fluid
                    textAlign="center"
                    icon="clone"
                    content="Копия"
                    disabled={data.toner === 0 || !data.copyitem && !data.mob}
                    onClick={() => act("copy")}
                  />
                  </Flex.Item>
                  <Flex.Item width="40%" mr="3px">
                  <Button
                    fluid
                    textAlign="center"
                    icon="file"
                    disabled={data.toner === 0 || data.form === null}
                    content="Печать"
                    onClick={() => act("print_form")}
                  />
                  </Flex.Item>
                  <Flex.Item width="30%" mr="3px">
                  <Button
                    fluid
                    textAlign="center"
                    icon="print"
                    content="Скан"
                    onClick={() => act("scandocument")}
                  />
                  </Flex.Item>
                </Flex>
                <Flex>
                  <Flex.Item width="100%" mr="5px">
                  {!!data.isAI && (
                  <Button
                    fluid
                    textAlign="center"
                    icon="terminal"
                    disabled={data.toner === 0}
                    content="Фото из БД"
                    onClick={() => act("aipic")}
                  />
                  )}
                  </Flex.Item>
                </Flex>
                <Flex>
                  <Flex.Item mr="10px" mt="10px" color="grey">
                    Количество:
                  </Flex.Item>
                  <Flex.Item mr="15px" mt="10px">
                  {data.copynumber}
                  </Flex.Item>
                  <Flex.Item mr="3px" mt="8px">
                    <Button
                      fluid
                      icon="minus"
                      textAlign="center"
                      content=""
                      onClick={() => act('minus')}
                    />
                  </Flex.Item>
                  <Flex.Item mr="3px" mt="8px">
                  <Button
                    fluid
                    icon="plus"
                    textAlign="center"
                    content=""
                    onClick={() => act('add')}
                  />
                  </Flex.Item>
                </Flex>
            </Section>
            <Section
              title="Бюрократия">
              <Flex>
                <Flex.Item mr="20px">
                  Форма:
                </Flex.Item>
                <FlexItem>
                  {data.form_id === "" ? "Не выбрана" : data.form_id}
                </FlexItem>
              </Flex>
              <Flex
                direction="column"
                mt={2}>
                <Flex.Item>
                  <Button
                    fluid
                    icon="chevron-right"
                    content="Все формы"
                    selected={data.category === "" ? "selected" : null}
                    onClick={() => act("choose_category", {
                      category: null,
                    })}
                    mb={1}
                  />
                </Flex.Item>
                {categories.map(category => (
                  <Flex.Item key={category}>
                    <Button fluid key={category}
                      icon="chevron-right"
                      content={category}
                      selected={data.category === category ? "selected" : null}
                      onClick={() => act("choose_category", {
                        category: category,
                      })}
                      mb={1}
                    />
                  </Flex.Item>
                ))}
              </Flex>
            </Section>
          </Flex.Item>
          <Flex.Item
            width={35}>
            <Section
              title = {data.category === "" ? "Все формы" : data.category}>
              <Flex
                direction="column"
                mt={2}>
                {category.map(form => (
                  <Flex.Item key={form.path}>
                    <Button fluid key={form.path}
                      content={form.id + ": " + form.altername.trimLongStr(35)}
                      tooltip={form.id + ": " + form.altername}
                      selected={data.form === form.path ? "selected" : null}
                      onClick={() => act("choose_form", {
                        path: form.path,
                        id: form.id,
                      })}
                      mb={1}
                    />
                  </Flex.Item>
                ))}
              </Flex>
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
