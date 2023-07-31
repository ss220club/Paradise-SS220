import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, Flex, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { sortBy } from "common/collections";

export const Photocopier220 = (props, context) => {
  const { act, data } = useBackend(context);
  if (data.mode === "mode_aipic" && !data.isAI) {
    act("mode_copy");
  }

  const forms = sortBy(
    form => form.category,)(data.forms || []);

  const categories = [];
  for (let form of forms) {
    if (!categories.includes(form.category)) {
      categories.push(form.category);
    }
  }

  let category;
  if (data.category === "") {
    category = forms;
  }
  else {
    category = forms.filter(form => form.category === data.category);
  }
  return (
    <Window resizable>
      <Window.Content
        scrollable
        display="flex"
        className="Layout__content--flexColumn"
      >
        <Section title="Ксерокс" color="silver">
          <LabeledList>
            <LabeledList.Item label="Copies">
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
            <LabeledList.Item label="Toner">
              <Box bold>{data.toner}</Box>
            </LabeledList.Item>
            <LabeledList.Item label="Inserted Document">
              <Button
                fluid
                textAlign="center"
                disabled={!data.copyitem && !data.mob}
                content={
                  data.copyitem
                    ? data.copyitem
                    : data.mob
                    ? data.mob + "'s ass!"
                    : 'document'
                }
                onClick={() => act('removedocument')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Inserted Folder">
              <Button
                fluid
                textAlign="center"
                disabled={!data.folder}
                content={data.folder ? data.folder : 'folder'}
                onClick={() => act('removefolder')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section>
          <Actions />
        </Section>
        <Files />
      </Window.Content>
    </Window>
  );
};

const Actions = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Fragment>
      <Button
        fluid
        icon="copy"
        float="center"
        textAlign="center"
        content="Copy"
        onClick={() => act('copy')}
      />
      <Button
        fluid
        icon="file-import"
        float="center"
        textAlign="center"
        content="Scan"
        onClick={() => act('scandocument')}
      />
    </Fragment>
  );
};

const Files = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section title="Scanned Files">
      {data.files.map((file) => (
        <Section
          key={file.name}
          title={file.name}
          buttons={
            <Flex>
              <Button
                icon="print"
                content="Print"
                disabled={data.toner <= 0}
                onClick={() =>
                  act('filecopy', {
                    uid: file.uid,
                  })
                }
              />
              <Button.Confirm
                icon="trash-alt"
                content="Delete"
                color="bad"
                onClick={() =>
                  act('deletefile', {
                    uid: file.uid,
                  })
                }
              />
            </Flex>
          }
        />
      ))}
    </Section>
  );
};
