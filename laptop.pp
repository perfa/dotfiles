### <3 Creating A Lovely Ubuntu <3 ###


### PACKAGES!! :D ###
$development = [ 
                 "git",
                 "tig",
                 "vim",
                 "python-flake8",
                 "python-nose",
                 "python-pip",
                 "python-nosexcover",
                 "python-hamcrest",
                 "nodejs",
                 "npm",
                 "cmake",
                 "maven",
                 "expect",
                 "strongswan",
                 "strongswan-plugin-xauth-generic",
                 "tmux"
                ]
package { $development: ensure => "installed" }

$desktop = [
             "sl",
             "gnupg",
             "tree",
             "chromium-browser",
             "aptitude",
             "synaptic",
             "gimp",
             "htop",
             "gparted",
             "vlc",
            ]
package { $desktop: ensure => "installed" }

exec { "accept-msttcorefonts-license":
    command => "/bin/sh -c \"echo ttf-mscorefonts-installer msttcorefonts/accepted-     mscorefonts-eula select true | debconf-set-selections\""
}

package { "ubuntu-extras-restricted":
    ensure  => installed,
    require => Exec['accept-msttcorefonts-license']
}

### SETTINGS!! :D ###
$home = '/home/mango'
$dotfiles = "$home/.dotfiles"
exec { "get_dotfiles":
     command => "/bin/bash -c \"cd $home && git clone https://github.com/perfa/dotfiles.git .dotfiles\"",
     creates => $dotfiles,
     }

File {
     owner => 'mango',
     group => 'mango',
     }

file { $dotfiles: }

file { "$home/bin":
     ensure => directory,
     }

file { "$home/bin/git_completion.sh":
     ensure  => link,
     target  => "$dotfiles/bin/git_completion.sh",
     require => [ File[$dotfiles], File["$home/bin"] ],
     }

file { "$home/.gitconfig":
     ensure  => link,
     target  => "$dotfiles/.gitconfig",
     require => File[$dotfiles],
     }

file { "$home/.gitignore":
     ensure  => link,
     target  => "$dotfiles/.gitignore",
     require => File[$dotfiles],
     }

file { "$home/.emacs":
     ensure  => link,
     target  => "$dotfiles/.emacs",
     require => File[$dotfiles], }

file { "$home/.emacs.d":
     ensure  => link,
     target  => "$dotfiles/.emacs.d",
     require => File[$dotfiles],
     }
file { "$home/.vim":
     ensure  => link,
     target  => "$dotfiles/.vim",
     require => File[$dotfiles],
     }

file { "$home/.vimrc":
     ensure  => link,
     target  => "$dotfiles/.vimrc",
     require => File[$dotfiles],
     }

file { "$home/.bashrc.private":
     ensure  => link,
     target  => "$dotfiles/.bashrc.private",
     require => File[$dotfiles],
     }

file_line { 'include private bash settings':
    ensure => present,
    line   => '. ~/.bashrc.private',
    path   => '/home/mango/.bashrc',
}

### Thinkpad/Lenovo Power control (TLP) and UbuntuTweak ###
# These two need some special apt lovin', as they have their own PPA's
include apt

apt::source { 'linrunner_tlp':
    location    => 'http://ppa.launchpad.net/linrunner/tlp/ubuntu',
    repos       => 'main',
    include_src => true,
    key         => '02D65EFF',
    key_server  => 'keyserver.ubuntu.com',
    }

apt::source { 'ubuntu_tweak':
    location    => 'http://ppa.launchpad.net/tualatrix/ppa/ubuntu',
    repos       => 'main',
    include_src => false,
    key         => 'E260F5B0',
    key_server  => 'keyserver.ubuntu.com',
    }

apt::source { 'noobslab/themes':
    location    => 'http://ppa.launchpad.net/noobslab/themes/ubuntu',
    repos       => 'main',
    include_src => 'false',
    key         => '0D188ACB',
    key_server  => 'keyserver.ubuntu.com'
}

$tlp_pkgs = [
             "tlp",
             "tlp-rdw",
             "tp-smapi-dkms",
             "acpi-call-tools",
            ]

package { $tlp_pkgs: 
     ensure  => installed,
     require => Apt::Source[linrunner_tlp],
     }

package { "ubuntu-tweak":
     ensure  => installed,
     require => Apt::Source[ubuntu_tweak],
     }


### Fuck unity hidey-disappeary scrollbars!!!! :D ###
exec { "/usr/bin/gsettings set com.canonical.desktop.interface scrollbar-mode normal":
    user => "mango",
}
