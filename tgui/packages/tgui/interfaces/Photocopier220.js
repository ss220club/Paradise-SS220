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
  if (data.mode === "mode_aipic" && !data.isAI) {
    act("mode_copy");
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
                <Flex.Item width="40%" color="blue">
                  Заряд тонера:
                </Flex.Item>
                <Flex.Item mr="3px" color={data.toner > 0 ? "good" : "bad"}>
                  {data.toner}
                </Flex.Item>
                </Flex>
                <Flex>
                  <FlexItem width="40%" color="blue">
                    Слот сканера:
                  </FlexItem>
                  <Flex.Item mr="3px">
                    <Button
                      icon="sign-out-alt"
                      disabled={data.isAI || data.copyitem === null}
                      content="Извлечь"
                      onClick={() => act("removedocument")}
                      />
                  </Flex.Item>
                </Flex>
            </Section>

            <Section
              title="Управление">
                <Flex>
                  <Flex.Item width="40%" color="blue">
                    Режим:
                  </Flex.Item>
                  <Flex.Item mr="3px">
                  <Button
                    icon="file"
                    content="Копирование"
                    selected={data.mode === "mode_copy" ? "selected" : null}
                    onClick={() => act("mode_copy")}
                  />
                  </Flex.Item>
                  <Flex.Item mr="3px">
                  <Button
                    icon="file"
                    content="Печать"
                    disabled={data.toner === 0}
                    selected={data.mode === "mode_print" ? "selected" : null}
                    onClick={() => act("mode_print")}
                  />
                  </Flex.Item>
                  <Flex.Item mr="3px">
                  {!!data.isAI && (
                  <Button
                    icon="terminal"
                    disabled={data.toner === 0}
                    content="Фото из БД"
                    selected={data.mode === "mode_aipic" ? "selected" : null}
                    onClick={() => act("mode_aipic")}
                  />
                  )}
                  </Flex.Item>
                </Flex>
                <Flex>
                  <Flex.Item width="40%" color="blue">
                    Выполнить:
                  </Flex.Item>
                  <Flex.Item mr="3px" >
                  {data.mode === "mode_copy" && (
                  <Button
                      icon="print"
                      disabled={data.toner === 0
                        || (data.copyitem === null
                        && !data.ass)}
                      textAlign="center"
                      content="Копирование"
                      onClick={() => act("copy")}
                    />
                  )}
                  <Button
                    fluid
                    icon="file-import"
                    float="center"
                    textAlign="center"
                    content="Сканировать"
                    onClick={() => act('scandocument')}
                  />
                    </Flex.Item>
                    <Flex.Item mr="3px">
                    {data.mode === "mode_print" && (
                    <Button
                      icon="print"
                      disabled={data.toner === 0 || data.form === null}
                      content="Печать"
                      onClick={() => act("print_form")}
                    />
                    )}
                  </Flex.Item>
                </Flex>
                <Flex>
                  <Flex.Item width="40%" color="blue">
                    Количество:
                  </Flex.Item>
                  <Flex.Item>
                  {data.copynumber}
                  </Flex.Item>
                  <Flex.Item mr="3px">
                    <Button
                      fluid
                      icon="minus"
                      textAlign="center"
                      content=""
                      onClick={() => act('minus')}
                    />
                  </Flex.Item>
                  <Flex.Item mr="3px">
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
                <Flex.Item width="40%">
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
                  <Button fluid
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
