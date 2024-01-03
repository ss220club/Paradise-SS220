import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { createSearch, decodeHtmlEntities } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Flex, Input, Section, Tabs } from '../components';
import { FlexItem } from '../components/Flex';
import { Window } from '../layouts';
import { ComplexModal } from './common/ComplexModal';

const PickTab = (index) => {
  switch (index) {
    case 0:
      return <ItemsPage />;
    case 2:
      return <CartPage />;
    case 3:
      return <MedicalPage />; // !!!!!!!! МЕДИЦИНСКАЯ СТРАНИЦА С ДАННЫМИ ЖИЗНЕОБЕСПЕЧЕНИЯ ВСЕХ ВОКСОВ
    default:
      return 'ОШИБКА, СООБЩИТЕ РАЗРАБОТЧИКУ';
  }
};


export const VoxShop = (props, context) => {
  const { act, data } = useBackend(context);
  const { cart } = data;

  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);

  return (
    <Window theme="abductor">
      <ComplexModal />
      <Window.Content scrollable>
        <Tabs>

          <Tabs.Tab
            key="PurchasePage"
            selected={tabIndex === 0}
            onClick={() => {
              setTabIndex(0);
            }}
            icon="store"
          >
            Торговля
          </Tabs.Tab>


          <Tabs.Tab
            key="Cart"
            selected={tabIndex === 1}
            onClick={() => {
              setTabIndex(1);
            }}
            icon="shopping-cart"
          >
            View Shopping Cart{' '}
            {cart && cart.length ? '(' + cart.length + ')' : ''}
          </Tabs.Tab>



          <Tabs.Tab
            key="Medical"
            selected={tabIndex === 2}
            onClick={() => {
              setTabIndex(2);
            }}
            icon=""
          >
            Жизнеобеспечение
          </Tabs.Tab>



          <Tabs.Tab
            key="GetCash"
            // This cant ever be selected. Its just a close button.
            onClick={() => act('cash')}
            icon="undo"
          >
            Выгрузить Кикиридиты
          </Tabs.Tab>

        </Tabs>
        {PickTab(tabIndex)}

      </Window.Content>
    </Window>
  );
};



// ================== ITEMS PAGE ==================

const ItemsPage = (_properties, context) => {
  const { act, data } = useBackend(context);
  const { cash, cats } = data;
  // Default to first
  const [shopItems, setShopItems] = useLocalState(
    context,
    'shopItems',
    cats[0].items
  );

  const [showDesc, setShowDesc] = useLocalState(context, 'showDesc', 1);

  return (
    <Section
      title={'Средства: ' + cash + 'Кикиридитов'}
      buttons={
        <Fragment>
          <Button.Checkbox
            content="Описание"
            checked={showDesc}
            onClick={() => setShowDesc(!showDesc)}
          />
        </Fragment>
      }
    >
      <Flex>

        <FlexItem>
          <Tabs vertical>
            {cats.map((c) => (
              <Tabs.Tab
                key={c}
                selected={c.items === shopItems}
                onClick={() => {
                  setShopItems(c.items);
                }}
              >
                {c.cat}
              </Tabs.Tab>
            ))}
          </Tabs>
        </FlexItem>

        <Flex.Item grow={1} basis={0}>
          {shopItems.map((i) => (
            <ShopItem
              i={i}
              showDecription={showDesc}
              key={decodeHtmlEntities(i.name)}
            />
          ))}
        </Flex.Item>

      </Flex>
    </Section>
);
};


const ShopItem = (props, context) => {
  const {
    i,
    showDecription = 1,
    buttons = <ShopItemButtons i={i} />,
  } = props;

  return (
    <Section
      title={decodeHtmlEntities(i.name)}
      showBottom={showDecription}
      borderRadius="5px"
      buttons={buttons}
      stretchContents
    >
      {showDecription ? <Box italic>{decodeHtmlEntities(i.desc)}</Box> : null}
    </Section>
  );
};

const ShopItemButtons = (props, context) => {
  const { act, data } = useBackend(context);
  const { i } = props;
  const { cash } = data;

  return (
    <Fragment>
      <Button
        icon="shopping-cart"
        content={
          'Купить (' + i.cost + 'Кикиридитов)'
        }
        color={i.hijack_only === 1 && 'red'}
        tooltip="Добавить в корзину."
        tooltipPosition="left"
        onClick={() =>
          act('add_to_cart', {
            item: i.obj_path,
          })
        }
        disabled={i.cost > cash}
      />

    </Fragment>
  );
};



// ================== CART PAGE ==================

const CartPage = (_properties, context) => {
  const { act, data } = useBackend(context);
  const { cart, cash, cart_price } = data;

  const [showDesc, setShowDesc] = useLocalState(context, 'showDesc', 0);

  return (
    <Fragment>
      <Section
        title={'Средства: ' + cash + 'Кикиридитов'}
        buttons={
          <Fragment>
            <Button.Checkbox
              content="Описание"
              checked={showDesc}
              onClick={() => setShowDesc(!showDesc)}
            />
            <Button
              content="Очистить"
              icon="trash"
              onClick={() => act('empty_cart')}
              disabled={!cart}
            />
            <Button
              content={'Оплатить (' + cart_price + ' Кикиридитов)'}
              icon="shopping-cart"
              onClick={() => act('purchase_cart')}
              disabled={!cart || cart_price > cash}
            />
          </Fragment>
        }
      >

        <Flex.Item grow={1} basis={0}>
          {cart ? (
            cart.map((i) => (
              <ShopItem
                i={i}
                showDecription={showDesc}
                key={decodeHtmlEntities(i.name)}
                buttons={<CartButtons i={i} />}
              />
            ))
          ) : (
            <Box italic>Список выбранных товаров пуст!</Box>
          )}
        </Flex.Item>

      </Section>
    </Fragment>
  );
};


const CartButtons = (props, context) => {
  const { act, data } = useBackend(context);
  const { i } = props;
  const { cash } = data;

  return (
    <Flex>
      <Button
        icon="times"
        content={'(' + i.cost * i.amount + 'Кикиридитов)'}
        tooltip="Убрать из корзины"
        tooltipPosition="left"
        onClick={() =>
          act('remove_from_cart', {
            item: i.obj_path,
          })
        }
      />
      <Button
        icon="minus"
        tooltip={'Текст3'}
        ml="5px"
        onClick={() =>
          act('set_cart_item_amount', {
            item: i.obj_path,
            amount: --i.amount, // one lower
          })
        }
        disabled={i.amount <= 0}
      />
      <Button.Input
        content={i.amount}
        width="45px"
        tooltipPosition="bottom-left"
        tooltip={'Текст1'}
        onCommit={(e, value) =>
          act('set_cart_item_amount', {
            item: i.obj_path,
            amount: value,
          })
        }
        disabled={i.amount <= 0}
      />
      <Button
        icon="plus"
        tooltipPosition="bottom-left"
        tooltip={'Текст2'}
        onClick={() =>
          act('set_cart_item_amount', {
            item: i.obj_path,
            amount: ++i.amount, // one higher
          })
        }
        disabled={i.cost > cash}
      />
    </Flex>
  );
};



// ================== MEDICAL PAGE ==================

const MedicalPage = (_properties, context) => {
  const { act, data } = useBackend(context);
  const crew = sortBy((cm) => cm.name)(data.crewmembers || []);
  const [search, setSearch] = useLocalState(context, 'search', '');
  const searcher = createSearch(search, (cm) => {
    return cm.name + '|' + cm.assignment + '|' + cm.area;
  });
  return (
    <Box>
      <Input
        placeholder="Search by name, assignment or location.."
        width="100%"
        onInput={(_e, value) => setSearch(value)}
      />
      <Table m="0.5rem">
        <Table.Row header>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell>Status</Table.Cell>
          <Table.Cell>Location</Table.Cell>
        </Table.Row>
        {crew.filter(searcher).map((cm) => (
          <Table.Row key={cm.name} bold={!!cm.is_command}>
            <TableCell>
              {cm.name} ({cm.assignment})
            </TableCell>
            <TableCell>
              <Box inline color={getStatColor(cm, data.critThreshold)}>
                {getStatText(cm, data.critThreshold)}
              </Box>
              {cm.sensor_type >= 2 ? (
                <Box inline ml={1}>
                  {'('}
                  <Box inline color={COLORS.damageType.oxy}>
                    {cm.oxy}
                  </Box>
                  {'|'}
                  <Box inline color={COLORS.damageType.toxin}>
                    {cm.tox}
                  </Box>
                  {'|'}
                  <Box inline color={COLORS.damageType.burn}>
                    {cm.fire}
                  </Box>
                  {'|'}
                  <Box inline color={COLORS.damageType.brute}>
                    {cm.brute}
                  </Box>
                  {')'}
                </Box>
              ) : null}
            </TableCell>
            <TableCell>
              {cm.sensor_type === 3 ? (
                data.isAI ? (
                  <Button
                    fluid
                    icon="location-arrow"
                    content={cm.area + ' (' + cm.x + ', ' + cm.y + ')'}
                    onClick={() =>
                      act('track', {
                        track: cm.ref,
                      })
                    }
                  />
                ) : (
                  cm.area + ' (' + cm.x + ', ' + cm.y + ')'
                )
              ) : (
                <Box inline color="grey">
                  Not Available
                </Box>
              )}
            </TableCell>
          </Table.Row>
        ))}
      </Table>
    </Box>
  );
};
