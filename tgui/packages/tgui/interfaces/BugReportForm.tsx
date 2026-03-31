import React, { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Flex, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
interface FormTypes {
  awaiting_approval: BooleanLike;
  report_details: FormDetails;
}

// all the information necessary to pass into the github api
type FormDetails = {
  steps: string;
  title: string;
  description: string;
  expected_behavior: string;
  consequences: string;
  approver_note: string;
  log: string;
};

const InputTitle = (props) => {
  return (
    <h2>
      {props.children}
      {props.required && <span className="input-title-required">{' *'}</span>}
    </h2>
  );
};

export const BugReportForm = (props) => {
  const { act, data } = useBackend<FormTypes>();
  const { awaiting_approval, report_details } = data;
  const [checkBox, setCheckbox] = useState(false);

  const [title, setTitle] = useState(report_details?.title || '');
  const [steps, setSteps] = useState(report_details?.steps || '');
  const [description, setDescription] = useState(report_details?.description || '');
  const [expected_behavior, setExpectedBehavior] = useState(report_details?.expected_behavior || '');
  const [consequences, setConsequences] = useState(report_details?.consequences || '');
  const [approver_note, setApproverNote] = useState(report_details?.approver_note || '');
  const [log, setLog] = useState(report_details?.log || '');

  const submit = () => {
    if (!title || !description || !expected_behavior || !steps || !consequences) {
      alert('Please fill out all required fields!');
      return;
    }
    const updatedReportDetails = {
      title,
      expected_behavior,
      description,
      consequences,
      steps,
      log,
      approver_note,
    };
    act('confirm', updatedReportDetails);
  };

  return (
    <Window title={'Bug Report Form'} width={700} height={awaiting_approval ? 1000 : 700}>
      <Window.Content>
        <Section fill scrollable>
          <Flex direction="column" height="100%">
            <Flex.Item className="text-center">
              <a
                href="https://github.com/ss220club/Paradise-SS220/issues"
                target="_blank"
                rel="noreferrer"
                className="link"
              >
                GitHub Repository
              </a>
            </Flex.Item>
            <Flex.Item>
              <h2 className="tip">
                {'TIP: Пожалуйста, опишите проблему как можно более подробно, это действительно сильно помогает'}
              </h2>
            </Flex.Item>
            <Flex.Item>
              <InputTitle required>{'Название отчета'}</InputTitle>
              <input width="100%" className="textarea" value={title} onChange={(e) => setTitle(e.target.value)} />
            </Flex.Item>
            <Flex.Item my={2}>
              <InputTitle required>{'Что должно было случиться?'}</InputTitle>
              {'Опишите, что по вашему мнению должно было произойти'}
              <textarea
                rows={3}
                className="textarea"
                onInput={(e) => {
                  const target = e.target as HTMLTextAreaElement;
                  target.style.height = 'auto';
                  target.style.height = `${target.scrollHeight}px`;
                }}
                value={expected_behavior}
                onChange={(e) => setExpectedBehavior(e.target.value)}
              />
            </Flex.Item>
            <Flex.Item my={2}>
              <InputTitle required>{'Что произошло на самом деле?'}</InputTitle>
              {'Опишите проблему'}
              <textarea
                rows={3}
                className="textarea"
                onInput={(e) => {
                  const target = e.target as HTMLTextAreaElement;
                  target.style.height = 'auto';
                  target.style.height = `${target.scrollHeight}px`;
                }}
                value={description}
                onChange={(e) => setDescription(e.target.value)}
              />
            </Flex.Item>
            <Flex.Item my={2}>
              <InputTitle required>{'Почему это плохо/Каковы последствия?'}</InputTitle>
              {'Проблема из-за бага:'}
              <textarea
                rows={3}
                className="textarea"
                onInput={(e) => {
                  const target = e.target as HTMLTextAreaElement;
                  target.style.height = 'auto';
                  target.style.height = `${target.scrollHeight}px`;
                }}
                value={consequences}
                onChange={(e) => setConsequences(e.target.value)}
              />
            </Flex.Item>
            <Flex.Item my={2}>
              <InputTitle required>{'Как мы можем воспроизвести этот баг?'}</InputTitle>
              {'Дайте список шагов для воспроизведения этой проблемы, чем больше деталей, тем лучше'}
              <textarea
                rows={4}
                className="textarea"
                onInput={(e) => {
                  const target = e.target as HTMLTextAreaElement;
                  target.style.height = 'auto';
                  target.style.height = `${target.scrollHeight}px`;
                }}
                value={steps}
                onChange={(e) => setSteps(e.target.value)}
                placeholder={'1) Step 1\n2) Step 2\n3) Step 3\n'}
              />
            </Flex.Item>
            {!!awaiting_approval && (
              <Flex.Item my={2}>
                <InputTitle>{'Дополнительные заметки'}</InputTitle>
                {'Любые дополнительные заметки для отправки вместе с отчетом об ошибке автора '}
                <textarea
                  rows={4}
                  className="textarea"
                  onInput={(e) => {
                    const target = e.target as HTMLTextAreaElement;
                    target.style.height = 'auto';
                    target.style.height = `${target.scrollHeight}px`;
                  }}
                  value={approver_note}
                  onChange={(e) => setApproverNote(e.target.value)}
                />
              </Flex.Item>
            )}
            <Flex.Item my={2}>
              <InputTitle>{'Logs'}</InputTitle>
              {'Пожалуйста, прикрипите любые походящие логи здесь'}
              <textarea
                rows={4}
                className="textarea"
                onInput={(e) => {
                  const target = e.target as HTMLTextAreaElement;
                  target.style.height = 'auto';
                  target.style.height = `${target.scrollHeight}px`;
                }}
                value={log}
                onChange={(e) => setLog(e.target.value)}
              />
            </Flex.Item>
            <Flex.Item my={2}>
              <Flex className="flex-center">
                <Flex.Item mx={1}>
                  <div className="button-cancel" onClick={() => act('cancel')}>
                    {awaiting_approval ? 'Reject' : 'Cancel'}
                  </div>
                </Flex.Item>
                <Flex.Item mx={1}>
                  <div className="button-submit" onClick={submit}>
                    {awaiting_approval ? 'Approve' : 'Submit'}
                  </div>
                </Flex.Item>
              </Flex>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
