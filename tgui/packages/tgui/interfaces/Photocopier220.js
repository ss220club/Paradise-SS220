import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, Section, Box, Flex, NoticeBox } from "../components";
import { Window } from '../layouts';
import { sortBy } from "common/collections";

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
      <Window.Content>
        <Flex
          direction="row"
          spacing={1}>
          <Flex.Item
            width={24}
            shrink={0}>
            <Section>
              <Box bold m={1}>
                Статус
              </Box>
              <LabeledList>
                <LabeledList.Item label="Заряд тонера"
                  color={data.toner > 0 ? "good" : "bad"}>
                  {data.toner}
                </LabeledList.Item>
                <LabeledList.Item label="Слот сканера">
                  <Button
                    icon="sign-out-alt"
                    disabled={data.isAI || data.copyitem === null}
                    content="Извлечь"
                    onClick={() => act("removedocument")}
                  />
                </LabeledList.Item>
              </LabeledList>
              <Box bold m={1}>
                Управление
              </Box>
              <LabeledList>
                <LabeledList.Item label="Количество">
                <Flex>
                <Box width="2em" bold>
                  {data.copynumber}
                </Box>
                <Fragment float="right">
                  <Button
                    fluid
                    icon="minus"
                    textAlign="center"
                    content=""
                    onClick={() => act('minus')}
                  />
                  <Button
                    fluid
                    icon="plus"
                    textAlign="center"
                    content=""
                    onClick={() => act('add')}
                  />
                </Fragment>
              </Flex>
                </LabeledList.Item>
                <LabeledList.Item label="Режим">
                   <Button
                    icon="file"
                    disabled={data.toner === 0}
                    content="Сканирование"
                    selected={data.mode === "mode_print" ? "selected" : null}
                    onClick={() => act("mode_scan")}
                  />
                  <Button
                    icon="clone"
                    disabled={data.toner === 0}
                    content="Копирование"
                    selected={data.mode === "mode_copy" ? "selected" : null}
                    onClick={() => act("mode_copy")}
                  />
                  <Button
                    icon="file"
                    disabled={data.toner === 0}
                    content="Печать"
                    selected={data.mode === "mode_print" ? "selected" : null}
                    onClick={() => act("mode_print")}
                  />
                  {!!data.isAI && (
                    <Button
                      icon="terminal"
                      disabled={data.toner === 0}
                      content="Фото из ДБ"
                      selected={data.mode === "mode_aipic" ? "selected" : null}
                      onClick={() => act("mode_aipic")}
                    />
                  )}
                </LabeledList.Item>
                <LabeledList.Item label="Выполнить">
                    <Button
                      icon="clone"
                      disabled={data.toner === 0
                        || (data.copyitem === null
                        && !data.ass)}
                      content="Копировать"
                      onClick={() => act("copy")}
                    />
                    <Button
                      icon="print"
                      disabled={data.toner === 0 || data.form === null}
                      content="Печать"
                      onClick={() => act("print_form")}
                    />
                  {data.mode === "mode_aipic" && (
                    <Button
                      icon="print"
                      disabled={data.toner === 0}
                      content="Печать фото"
                      onClick={() => act("aipic")}
                    />
                  )}
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section>
              <Box bold m={1}>
                Бюрократия
              </Box>
              <LabeledList>
                <LabeledList.Item label="Форма">
                  {data.form_id === "" ? "Не выбрана" : data.form_id}
                </LabeledList.Item>
              </LabeledList>
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
            <Section scrollable>
              <Box bold m={1}>
                {data.category === "" ? "Все формы" : data.category}
              </Box>
              <Flex
                direction="column"
                mt={2}>
                {category.map(form => (
                  <Flex.Item key={form.path}>
                    <Button fluid key={form.path}
                      content={form.id + ": " + form.altername.trimLongStr(30)}
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
