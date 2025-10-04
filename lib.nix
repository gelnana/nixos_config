{ lib, home-manager, ... }:

lib.extend (
  _: libprev: {
    hm = home-manager.lib.hm;
    custom = {
      mergeLists = lists: libprev.unique (libprev.concatLists lists);

      ensureList = x: if libprev.isList x then x else [ x ];
    };
  }
)
