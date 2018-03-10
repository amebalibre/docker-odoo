#!/bin/bash

# Replace variables of config file of odoo
# for Constants Environments of  container
if [ ! -z "$(grep -rl '$' $ODOO_RC)" ]; then

    set -e

    cat $ODOO_RC | envsubst > $ODOO_RC.tmp
    mv $ODOO_RC.tmp $ODOO_RC

fi

echo "Initialization Commands: $@"

    sleep 5
case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            # Scaffolding is the automated creation of a skeleton structure 
            # to simplify bootstrapping (of new modules, in the case of Odoo). 
            # While not necessary it avoids the tedium of setting up basic 
            # structures and looking up what all starting requirements are.
            exec odoo "$@"
        else
            exec odoo "$@" "${DB_ARGS[@]}"
        fi
        ;;
    -*)
        exec odoo "$@" "${DB_ARGS[@]}"
        ;;
    *)
        exec "$@"
esac

exit 1
