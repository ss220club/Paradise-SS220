import { BooleanLike } from 'common/react';
import { createSearch, toTitleCase } from 'common/string';
import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { useBackend, useSharedState } from '../backend';
import { Box, Button, ImageButton, Input, ProgressBar, Section, Stack, Tabs } from '../components';
import { Window } from '../layouts';

type Autolathe = {
  showhacked: BooleanLike;
  busyname: string;
  categories: string[];
  buildQueue: string[];
  buildQueueLen: number;
  fill_percent: number;
  metal_amount: number;
  glass_amount: number;
  busyamt: number;
  recipes: Recipe[];
};

type Recipe = {
  name: string;
  category: string[];
  uid: string;
  hacked: BooleanLike;
  max_multiplier: number;
  image: string;
  requirements: Requirement[];
};

type Requirement = {
  metal: number;
  glass: number;
};

const materials = ['metal', 'glass'];

const canBeMade = (recipe, mavail, gavail, multi) => {
  if (recipe.requirements === null) {
    return true;
  }
  if (recipe.requirements['metal'] * multi > mavail) {
    return false;
  }
  if (recipe.requirements['glass'] * multi > gavail) {
    return false;
  }
  return true;
};

const roundMaterials = (amount, multiplier) => {
  const roundedMaterial = Math.floor(((amount * multiplier) / 2000) * 100) / 100;
  if (roundedMaterial < 0.01) {
    return <Box fontSize={0.75}>{'< 0.01'}</Box>;
  }
  return roundedMaterial;
};

export const Autolathe220 = (props, context) => {
  const [category, setCategory] = useSharedState(context, 'category', 'Tools');

  return (
    <Window width={800} height={550}>
      <Window.Content>
        <Stack fill>
          <Stack.Item basis="20%">
            <Categories category={category} setCategory={setCategory} />
          </Stack.Item>
          <Stack.Item basis="55%">
            <Recipes category={category} />
          </Stack.Item>
          <Stack.Item basis="25%">
            <Stack fill vertical>
              <Materials />
              <Building />
              <Queue />
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const Categories = (props, context) => {
  const { act, data } = useBackend<Autolathe>(context);
  const { category, setCategory } = props;
  const { categories } = data;

  return (
    <Section fill scrollable title="Categories">
      <Tabs vertical>
        {categories.map((name) => (
          <Tabs.Tab
            key={name}
            mb={0.5}
            height="2.5em"
            color="blue"
            selected={name === category}
            onClick={() => setCategory(name)}
          >
            {name}
          </Tabs.Tab>
        ))}
      </Tabs>
    </Section>
  );
};

const Recipes = (props, context) => {
  const { act, data } = useBackend<Autolathe>(context);
  const { busyname, busyamt, metal_amount, glass_amount, recipes } = data;
  const { category } = props;

  const [searchText, setSearchText] = useSharedState(context, 'search_text', '');
  const recipesToShow = flow([
    filter((recipe) => (recipe.category.includes(category) || searchText) && (data.showhacked || !recipe.hacked)),
    searchText && filter(createSearch(searchText, (recipe: Recipe) => recipe.name)),
    sortBy((recipe) => recipe.name.toLowerCase()),
  ])(recipes);

  const MultiplierButton = (recipe, multiplier) => (
    <Button
      translucent
      width="32px"
      tooltip={materialsTooltip(recipe, multiplier)}
      tooltipPosition="top"
      disabled={!canBeMade(recipe, metal_amount, glass_amount, multiplier)}
      onClick={() =>
        act('make', {
          make: recipe.uid,
          multiplier,
        })
      }
    >
      {multiplier}x
    </Button>
  );

  const materialsTooltip = (recipe, multiplier) => (
    <>
      {materials.map(
        (material) =>
          recipe.requirements[material] && (
            <ImageButton key={material} asset={['materials32x32', material]} imageSize={32}>
              {roundMaterials(recipe.requirements[material], multiplier)}
            </ImageButton>
          )
      )}
    </>
  );

  return (
    <Section fill title={`Build (${category})`}>
      <Stack fill vertical>
        <Stack.Item>
          <Input fluid placeholder="Search for..." onInput={(e, v) => setSearchText(v)} mb={1} />
        </Stack.Item>
        <Stack.Item mt={-0.5} mb={-2} grow>
          <Section fill scrollable>
            {recipesToShow.map((recipe) => (
              <ImageButton
                key={recipe.name}
                fluid
                base64={recipe.image}
                imageSize={32}
                textAlign="left"
                tooltip={materialsTooltip(recipe, 1)}
                disabled={!canBeMade(recipe, metal_amount, glass_amount, 1)}
                buttons={
                  recipe.max_multiplier > 1 && (
                    <>
                      {recipe.max_multiplier >= 10 && MultiplierButton(recipe, 10)}
                      {recipe.max_multiplier >= 25 && MultiplierButton(recipe, 25)}
                      {recipe.max_multiplier > 25 && MultiplierButton(recipe, recipe.max_multiplier)}
                    </>
                  )
                }
                onClick={() =>
                  act('make', {
                    make: recipe.uid,
                    multiplier: 1,
                  })
                }
              >
                {recipe.name}
              </ImageButton>
            ))}
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const Materials = (props, context) => {
  const { act, data } = useBackend<Autolathe>(context);
  const { metal_amount, glass_amount, fill_percent } = data;

  const MaterialButton = (material, amount) => (
    <ImageButton
      fluid
      asset={['materials32x32', material]}
      buttons={
        <Box backgroundColor="rgba(255, 255, 255, 0.05)" width="45px">
          {roundMaterials(amount, 1)}
        </Box>
      }
    >
      {toTitleCase(material)}
    </ImageButton>
  );

  return (
    <Stack.Item>
      <Section title="Materials">
        {MaterialButton('metal', metal_amount)}
        {MaterialButton('glass', glass_amount)}
        <ProgressBar minValue={0} value={fill_percent} maxValue={100}>
          Storage {fill_percent}% full
        </ProgressBar>
      </Section>
    </Stack.Item>
  );
};

const Building = (props, context) => {
  const { act, data } = useBackend<Autolathe>(context);
  const { recipes, busyname, busyamt } = data;
  const recipe = recipes.find((recipe) => recipe.name === busyname);

  return (
    <Stack.Item>
      <Section title="Building">
        <ImageButton fluid color={busyname && 'green'} base64={recipe?.image} imageSize={32}>
          {busyname ? (busyamt > 1 ? `${busyname} x${busyamt}` : busyname) : 'Nothing'}
        </ImageButton>
      </Section>
    </Stack.Item>
  );
};

const Queue = (props, context) => {
  const { act, data } = useBackend<Autolathe>(context);
  const { recipes, buildQueue, buildQueueLen } = data;

  let buildQueueItems;
  if (buildQueueLen > 0) {
    buildQueueItems = buildQueue.map((queueItem, i) => {
      const recipe = recipes.find((recipe) => recipe.name === buildQueue[i][0]);
      return (
        <ImageButton
          key={i}
          fluid
          base64={recipe.image}
          imageSize={32}
          buttons={
            <Button
              key={queueItem}
              translucent
              width="32px"
              icon="times"
              iconColor="red"
              onClick={() =>
                act('remove_from_queue', {
                  remove_from_queue: buildQueue.indexOf(queueItem) + 1,
                })
              }
            />
          }
        >
          {recipe.name} {Number(buildQueue[i][1]) > 1 && `x${buildQueue[i][1]}`}
        </ImageButton>
      );
    });
  }

  return (
    <Stack.Item grow>
      <Stack fill vertical>
        <Stack.Item grow>
          <Section fill scrollable title={`Queue ${buildQueueLen > 0 ? buildQueueLen : ''}`}>
            {buildQueueItems}
          </Section>
        </Stack.Item>
        <Stack.Item m={0}>
          <Section fitted p={0.75}>
            <Button
              fluid
              translucent={!buildQueueLen}
              color="red"
              icon="trash-can"
              disabled={!buildQueueLen}
              onClick={() => act('clear_queue')}
            >
              Clear Queue
            </Button>
          </Section>
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};
