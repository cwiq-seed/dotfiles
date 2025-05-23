# gpg/core.bash
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::
# GPG Key Management Functions
#
# This script provides functions to manage GPG keys, including creating,
# deleting, and exporting keys. It also includes a function to retrieve
# the fingerprint of a GPG key associated with a given email address.
#
#
[ -n "$_GPG_CORE" ] && return 0
_GPG_CORE=1

GPG_HERE="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" \
    &> /dev/null && pwd 2> /dev/null; )";

. "${GPG_HERE:?}/../logger/core.bash"
. "${GPG_HERE:?}/public.bash"
. "${GPG_HERE:?}/private.bash"
. "${GPG_HERE:?}/primary.bash"
. "${GPG_HERE:?}/backup.bash"
. "${GPG_HERE:?}/restore.bash"


# :::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Check if GPG is installed and configured for SSH
gpg::init() {

    # Check if gpg is installed
    if ! command -v gpg &> /dev/null; then
	logger::error "gpg is not installed. Please install it to use gpg."
	return 1
    fi

    # Check if gpg-agent is running
    if ! pgrep -x "gpg-agent" > /dev/null; then

	if ! gpg-agent --daemon > /dev/null 2>&1; then
	    logger::error "gpg-agent is not running. Please start it to use gpg."
	    return 1
	fi
    fi

    # Check if gpg is configured for SSH
    if ! gpgconf --list-dirs agent-ssh-socket > /dev/null; then
	logger::error "gpg is not configured for SSH. Please configure it to use gpg."
	return 1
    fi

    return 0
}
