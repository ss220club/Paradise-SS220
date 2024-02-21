import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { decodeHtmlEntities } from 'common/string';
import { useBackend, useLocalState } from '../backend';
import {
  Box,
  Button,
  Input,
  Section,
  Stack,
  Tabs,
  LabeledList,
} from '../components';
import { Window } from '../layouts';
import { ComplexModal } from './common/ComplexModal';

const PickTab = (index) => {
  switch (index) {
    case 0:
      return <ItemsPage />;
    case 1:
      return <CartPage />;
    default:
      return 'ОШИБКА, СООБЩИТЕ РАЗРАБОТЧИКУ';
  }
};

export const Shop = (props, context) => {
  const { act, data } = useBackend(context);
  const { cart } = data;

  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);

  return (
    <Window width={900} height={600} theme="syndicate">
      <ComplexModal />
      <Window.Content scrollable>
        <Stack fill vertical>
          <Stack.Item>
            <Tabs>
              <Tabs.Tab
                key="PurchasePage"
                selected={tabIndex === 0}
                onClick={() => {
                  setTabIndex(0);
                }}
                icon="store"
              >
                View Market
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
                key="LockShop"
                // This cant ever be selected. Its just a close button.
                onClick={() => act('lock')}
                icon="lock"
              >
                Lock Shop
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>{PickTab(tabIndex)}</Stack.Item>
        </Stack>
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
    <Stack fill vertical>
      <Stack vertical>
        <Stack.Item>
          <Section
            title={'Current Balance: ' + cash + 'KK'}
            buttons={
              <>
                <Button.Checkbox
                  content="Show Descriptions"
                  checked={showDesc}
                  onClick={() => setShowDesc(!showDesc)}
                />
                <Button
                  content="Random Item"
                  icon="question"
                  onClick={() => act('buyRandom')}
                />
                <Button
                  content="Refund Currently Held Item"
                  icon="undo"
                  onClick={() => act('refund')}
                />
              </>
            }
          />
        </Stack.Item>
      </Stack>
      <Stack fill mt={0.3}>
        <Stack.Item width="30%">
          <Section fill scrollable>
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
          </Section>
        </Stack.Item>
        <Stack.Item grow>
          <Section fill scrollable>
            <Stack vertical>
              {shopItems.map((i) => (
                <Stack.Item
                  key={decodeHtmlEntities(i.name)}
                  p={1}
                  backgroundColor={'rgba(255, 0, 0, 0.1)'}
                >
                  <ShopItem
                    i={i}
                    showDecription={showDesc}
                    key={decodeHtmlEntities(i.name)}
                  />
                </Stack.Item>
              ))}
            </Stack>
          </Section>
        </Stack.Item>
      </Stack>
    </Stack>
  );
};

const CartPage = (_properties, context) => {
  const { act, data } = useBackend(context);
  const { cart, cash, cart_price } = data;

  const [showDesc, setShowDesc] = useLocalState(context, 'showDesc', 0);

  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <Section
          fill
          scrollable
          title={'Current Balance: ' + cash + 'KK'}
          buttons={
            <>
              <Button.Checkbox
                content="Show Descriptions"
                checked={showDesc}
                onClick={() => setShowDesc(!showDesc)}
              />
              <Button
                content="Empty Cart"
                icon="trash"
                onClick={() => act('empty_cart')}
                disabled={!cart}
              />
              <Button
                content={'Purchase Cart (' + cart_price + 'TC)'}
                icon="shopping-cart"
                onClick={() => act('purchase_cart')}
                disabled={!cart || cart_price > cash}
              />
            </>
          }
        >
          <Stack vertical>
            {cart ? (
              cart.map((i) => (
                <Stack.Item
                  key={decodeHtmlEntities(i.name)}
                  p={1}
                  mr={1}
                  backgroundColor={'rgba(255, 0, 0, 0.1)'}
                >
                  <ShopItem
                    i={i}
                    showDecription={showDesc}
                    buttons={<CartButtons i={i} />}
                  />
                </Stack.Item>
              ))
            ) : (
              <Box italic>Your Shopping Cart is empty!</Box>
            )}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const ShopItem = (props, context) => {
  const { i, showDecription = 1, buttons = <ShopItemButtons i={i} /> } = props;

  return (
    <Section
      title={decodeHtmlEntities(i.name)}
      showBottom={showDecription}
      buttons={buttons}
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
    <>
      <Button
        icon="shopping-cart"
        color={i.hijack_only === 1 && 'red'}
        tooltip="Add to cart."
        tooltipPosition="left"
        onClick={() =>
          act('add_to_cart', {
            item: i.obj_path,
          })
        }
        disabled={i.cost > cash}
      />
      <Button
        content={
          'Buy (' + i.cost + 'TC)' + (i.refundable ? ' [Refundable]' : '')
        }
        color={i.hijack_only === 1 && 'red'}
        // Yes I care this much about both of these being able to render at the same time
        tooltip={i.hijack_only === 1 && 'Hijack Agents Only!'}
        tooltipPosition="left"
        onClick={() =>
          act('buyItem', {
            item: i.obj_path,
          })
        }
        disabled={i.cost > cash}
      />
    </>
  );
};

const CartButtons = (props, context) => {
  const { act, data } = useBackend(context);
  const { i } = props;

  return (
    <Stack>
      <Button
        icon="times"
        content={'(' + i.cost * i.amount + 'TC)'}
        tooltip="Remove from cart."
        tooltipPosition="left"
        onClick={() =>
          act('remove_from_cart', {
            item: i.obj_path,
          })
        }
      />
      <Button
        icon="minus"
        tooltip={i.limit === 0 && 'Discount already redeemed!'}
        ml="5px"
        onClick={() =>
          act('set_cart_item_quantity', {
            item: i.obj_path,
            quantity: --i.amount, // one lower
          })
        }
        disabled={i.amount <= 0}
      />
      <Button.Input
        content={i.amount}
        width="45px"
        tooltipPosition="bottom-end"
        tooltip={i.limit === 0 && 'Discount already redeemed!'}
        onCommit={(e, value) =>
          act('set_cart_item_quantity', {
            item: i.obj_path,
            quantity: value,
          })
        }
        disabled={i.limit !== -1 && i.amount >= i.limit && i.amount <= 0}
      />
      <Button
        mb={0.3}
        icon="plus"
        tooltipPosition="bottom-start"
        tooltip={i.limit === 0 && 'Discount already redeemed!'}
        onClick={() =>
          act('set_cart_item_quantity', {
            item: i.obj_path,
            quantity: ++i.amount, // one higher
          })
        }
        disabled={i.limit !== -1 && i.amount >= i.limit}
      />
    </Stack>
  );
};
