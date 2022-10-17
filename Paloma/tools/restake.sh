#!/bin/bash
for (( ;; )); do
	echo -e "\033[0;32mCollecting rewards!\033[0m"
	palomad tx distribution withdraw-rewards $PALOMA_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$PALOMA_CHAIN_ID --yes
	echo -e "\033[0;32mWaiting 30 seconds before requesting balance\033[0m"
	sleep 30
	AMOUNT=$(palomad query bank balances $PALOMA_WALLET_ADDRESS | grep amount | awk '{split($0,a,"\""); print a[2]}')
	AMOUNT_STRING=$AMOUNT"ugrain"
	echo -e "Your total balance: \033[0;32m$AMOUNT_STRING\033[0m"
	palomad tx staking delegate $PALOMA_VALOPER_ADDRESS $AMOUNT_STRING --from $WALLET --chain-id $PALOMA_CHAIN_ID --yes
	echo -e "\033[0;32m$AMOUNT_STRING staked! Restarting in 90 sec!\033[0m"
	sleep 90
done
